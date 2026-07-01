param(
  [string]$PluginRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$PackageName = "pam-core"
$DistPath = Join-Path $PluginRoot "dist"
$StagingRoot = Join-Path $DistPath "_staging"

$IncludedPaths = @(
  "AGENTS.md",
  "README.md",
  "MODULES.md",
  "SKILL_DEPENDENCIES.md",
  "PROJECT_STATE.md",
  "DECISIONS.md",
  "VERSIONING.md",
  "skills",
  "scripts/install-unix.sh",
  "scripts/uninstall-unix.sh",
  "scripts/validate-unix.sh",
  "scripts/detect-agent.sh",
  "scripts/runtime-smoke-test.sh",
  "scripts/validate.ps1",
  "scripts/validate-claude.ps1",
  "docs/INSTALL_LINUX.md",
  "docs/INSTALL_MACOS.md",
  "docs/AGENT_COMPATIBILITY.md",
  "docs/PACKAGING.md",
  "docs/USAGE.md",
  "docs/LINUX_TEST_PLAN.md",
  "docs/KNOWN_LIMITATIONS.md",
  "docs/RELEASE_READINESS.md",
  "docs/runtime-tests"
)

$ExcludedPatterns = @(
  ".git/",
  "dist/",
  "logs/",
  "tmp/",
  "cache/",
  "*.bak",
  "*.tmp",
  "node_modules/",
  "__pycache__/",
  ".pytest_cache/",
  ".mypy_cache/",
  ".DS_Store",
  "Thumbs.db"
)

function Fail {
  param([string]$Message)
  throw $Message
}

function Get-PamVersion {
  $versionPath = Join-Path $PluginRoot "VERSION"
  if (Test-Path -LiteralPath $versionPath -PathType Leaf) {
    $version = (Get-Content -Raw -LiteralPath $versionPath).Trim()
    if ($version -match '^[0-9]+\.[0-9]+\.[0-9][0-9A-Za-z.+-]*$') {
      return $version
    }
    Fail "VERSION exists but does not contain a simple semver value"
  }

  $versioningPath = Join-Path $PluginRoot "VERSIONING.md"
  if (Test-Path -LiteralPath $versioningPath -PathType Leaf) {
    $versioningText = Get-Content -Raw -LiteralPath $versioningPath
    $versioningMatch = [regex]::Match($versioningText, '(?m)^\s*(?:Current version|Manifest version|Version):\s*`?([0-9]+\.[0-9]+\.[0-9][0-9A-Za-z.+-]*)`?\s*$')
    if ($versioningMatch.Success) {
      return $versioningMatch.Groups[1].Value
    }
  }

  $statePath = Join-Path $PluginRoot "PROJECT_STATE.md"
  if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    Fail "Missing PROJECT_STATE.md"
  }

  $text = Get-Content -Raw -LiteralPath $statePath
  $match = [regex]::Match($text, '(?m)^- Manifest version:\s*`?([0-9]+\.[0-9]+\.[0-9][0-9A-Za-z.+-]*)`?\s*$')
  if (-not $match.Success) {
    Fail "Could not read version from PROJECT_STATE.md"
  }
  return $match.Groups[1].Value
}

function Test-RuntimePending {
  $resultsPath = Join-Path $PluginRoot "docs\runtime-tests\RUNTIME_RESULTS.md"
  if (-not (Test-Path -LiteralPath $resultsPath -PathType Leaf)) {
    return $true
  }

  $runtimeRows = Get-Content -LiteralPath $resultsPath |
    Where-Object { $_ -match '^\|\s*(Claude Code|Codex CLI|Codex App)\s*\|' }

  foreach ($agent in @("Claude Code", "Codex CLI", "Codex App")) {
    $row = $runtimeRows | Where-Object { $_ -match "^\|\s*$([regex]::Escape($agent))\s*\|" } | Select-Object -First 1
    if (-not $row -or $row -notmatch '\|\s*supported\s*\|') {
      return $true
    }
  }

  return $false
}

function Copy-PackageItem {
  param(
    [string]$RelativePath,
    [string]$PackageRoot
  )

  $sourcePath = Join-Path $PluginRoot $RelativePath
  if (-not (Test-Path -LiteralPath $sourcePath)) {
    Fail "Missing required package input: $RelativePath"
  }

  $destinationPath = Join-Path $PackageRoot $RelativePath
  $destinationParent = Split-Path -Parent $destinationPath
  if (-not (Test-Path -LiteralPath $destinationParent)) {
    [void](New-Item -ItemType Directory -Path $destinationParent)
  }

  if (Test-Path -LiteralPath $sourcePath -PathType Container) {
    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Recurse
  } else {
    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath
  }
}

function Write-PackageManifest {
  param(
    [string]$PackageRoot,
    [string]$Version,
    [string]$Format
  )

  $sourceCommit = $null
  try {
    $sourceCommit = (git -C $PluginRoot rev-parse HEAD 2>$null)
  } catch {
    $sourceCommit = $null
  }

  $manifest = [ordered]@{
    name = $PackageName
    version = $Version
    created_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    source_commit = $sourceCommit
    package_format = $Format
    runtime_pending = (Test-RuntimePending)
    evidence_file = "docs/runtime-tests/RUNTIME_RESULTS.md"
    included_paths = $IncludedPaths
    excluded_patterns = $ExcludedPatterns
  }

  $json = $manifest | ConvertTo-Json -Depth 6
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText((Join-Path $PackageRoot "PACKAGE_MANIFEST.json"), $json + "`n", $utf8NoBom)
}

function New-ZipPackage {
  param(
    [string]$PackageRoot,
    [string]$ZipPath
  )

  if (Test-Path -LiteralPath $ZipPath) {
    Remove-Item -LiteralPath $ZipPath -Force
  }
  Compress-Archive -LiteralPath $PackageRoot -DestinationPath $ZipPath
}

function New-TarPackage {
  param(
    [string]$StagingRoot,
    [string]$RootName,
    [string]$TarPath
  )

  $tarCommand = Get-Command tar -ErrorAction SilentlyContinue
  if (-not $tarCommand) {
    Write-Warning "tar was not found; skipping tar.gz package"
    return
  }

  if (Test-Path -LiteralPath $TarPath) {
    Remove-Item -LiteralPath $TarPath -Force
  }
  & tar -czf $TarPath -C $StagingRoot $RootName
  if ($LASTEXITCODE -ne 0) {
    Fail "tar failed while creating $TarPath"
  }
}

function Write-Checksums {
  param([string[]]$PackagePaths)

  $checksumPath = Join-Path $DistPath "CHECKSUMS.txt"
  $lines = foreach ($path in ($PackagePaths | Where-Object { Test-Path -LiteralPath $_ } | Sort-Object)) {
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()
    "$hash  $(Split-Path -Leaf $path)"
  }
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($checksumPath, (($lines -join "`n") + "`n"), $utf8NoBom)
}

$version = Get-PamVersion
$rootName = "$PackageName-$version"
$packageRoot = Join-Path $StagingRoot $rootName
$zipPath = Join-Path $DistPath "$rootName.zip"
$tarPath = Join-Path $DistPath "$rootName.tar.gz"

if (-not (Test-Path -LiteralPath $DistPath)) {
  [void](New-Item -ItemType Directory -Path $DistPath)
}

if (Test-Path -LiteralPath $StagingRoot) {
  $resolvedStaging = (Resolve-Path -LiteralPath $StagingRoot).Path
  $resolvedDist = (Resolve-Path -LiteralPath $DistPath).Path
  if (-not $resolvedStaging.StartsWith($resolvedDist, [System.StringComparison]::OrdinalIgnoreCase)) {
    Fail "Refusing to remove staging path outside dist: $resolvedStaging"
  }
  Remove-Item -LiteralPath $StagingRoot -Recurse -Force
}

[void](New-Item -ItemType Directory -Path $packageRoot)
foreach ($path in $IncludedPaths) {
  Copy-PackageItem -RelativePath $path -PackageRoot $packageRoot
}

Write-PackageManifest -PackageRoot $packageRoot -Version $version -Format "zip"
New-ZipPackage -PackageRoot $packageRoot -ZipPath $zipPath

Write-PackageManifest -PackageRoot $packageRoot -Version $version -Format "tar.gz"
New-TarPackage -StagingRoot $StagingRoot -RootName $rootName -TarPath $tarPath

Write-Checksums -PackagePaths @($zipPath, $tarPath)
Remove-Item -LiteralPath $StagingRoot -Recurse -Force

Write-Host "Created package: $zipPath"
if (Test-Path -LiteralPath $tarPath) {
  Write-Host "Created package: $tarPath"
}
Write-Host "Created checksums: $(Join-Path $DistPath "CHECKSUMS.txt")"
