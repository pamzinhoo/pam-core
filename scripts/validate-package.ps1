param(
  [string]$PluginRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$DistPath = Join-Path $PluginRoot "dist"
$RequiredPaths = @(
  "PACKAGE_MANIFEST.json",
  "AGENTS.md",
  "README.md",
  "MODULES.md",
  "SKILL_DEPENDENCIES.md",
  "PROJECT_STATE.md",
  "DECISIONS.md",
  "VERSIONING.md",
  "skills/",
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
  "docs/runtime-tests/"
)
$ForbiddenPatterns = @(
  '(^|/)\.git(/|$)',
  '(^|/)dist(/|$)',
  '(^|/)logs(/|$)',
  '(^|/)tmp(/|$)',
  '(^|/)cache(/|$)',
  '(^|/)node_modules(/|$)',
  '(^|/)__pycache__(/|$)',
  '(^|/)\.pytest_cache(/|$)',
  '(^|/)\.mypy_cache(/|$)',
  '\.bak$',
  '\.tmp$',
  '(^|/)\.DS_Store$',
  '(^|/)Thumbs\.db$'
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
  $text = Get-Content -Raw -LiteralPath $statePath
  $match = [regex]::Match($text, '(?m)^- Manifest version:\s*`?([0-9]+\.[0-9]+\.[0-9][0-9A-Za-z.+-]*)`?\s*$')
  if (-not $match.Success) {
    Fail "Could not read version from PROJECT_STATE.md"
  }
  return $match.Groups[1].Value
}

function Normalize-ArchiveEntry {
  param([string]$Entry)
  return ($Entry -replace '\\', '/').TrimStart('/')
}

function Test-RequiredPath {
  param(
    [string[]]$Entries,
    [string]$Path
  )

  $path = $Path.TrimEnd("/")
  foreach ($entry in $Entries) {
    $normalized = Normalize-ArchiveEntry $entry
    $parts = $normalized -split '/', 2
    if ($parts.Count -lt 2) {
      continue
    }
    $inner = $parts[1]
    if ($inner -eq $path -or $inner.StartsWith("$path/", [System.StringComparison]::Ordinal)) {
      return $true
    }
  }
  return $false
}

function Test-ForbiddenEntries {
  param([string[]]$Entries)

  foreach ($entry in $Entries) {
    $normalized = Normalize-ArchiveEntry $entry
    foreach ($pattern in $ForbiddenPatterns) {
      if ($normalized -match $pattern) {
        Fail "Forbidden archive entry found: $normalized"
      }
    }
  }
}

function Get-ZipEntries {
  param([string]$ZipPath)

  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)
  try {
    return @($zip.Entries | ForEach-Object { $_.FullName })
  } finally {
    $zip.Dispose()
  }
}

function Get-TarEntries {
  param([string]$TarPath)

  $tarCommand = Get-Command tar -ErrorAction SilentlyContinue
  if (-not $tarCommand) {
    Fail "tar is required to inspect tar.gz packages"
  }
  $entries = @(& tar -tzf $TarPath)
  if ($LASTEXITCODE -ne 0) {
    Fail "tar failed while reading $TarPath"
  }
  return $entries
}

function Test-Manifest {
  param(
    [string]$ArchivePath,
    [string]$Format
  )

  $temp = Join-Path ([System.IO.Path]::GetTempPath()) ("pam-core-package-" + [System.Guid]::NewGuid().ToString("N"))
  [void](New-Item -ItemType Directory -Path $temp)
  try {
    if ($Format -eq "zip") {
      Expand-Archive -LiteralPath $ArchivePath -DestinationPath $temp
    } else {
      & tar -xzf $ArchivePath -C $temp
      if ($LASTEXITCODE -ne 0) {
        Fail "tar failed while extracting manifest from $ArchivePath"
      }
    }

    $manifestPath = Get-ChildItem -LiteralPath $temp -Recurse -File -Filter "PACKAGE_MANIFEST.json" |
      Select-Object -First 1
    if (-not $manifestPath) {
      Fail "PACKAGE_MANIFEST.json not found in $ArchivePath"
    }

    $manifest = Get-Content -Raw -LiteralPath $manifestPath.FullName | ConvertFrom-Json
    if ($manifest.name -ne "pam-core") {
      Fail "Manifest name must be pam-core in $ArchivePath"
    }
    if ($manifest.package_format -ne $Format) {
      Fail "Manifest package_format must be $Format in $ArchivePath"
    }
    if (-not $manifest.runtime_pending) {
      Fail "Manifest runtime_pending must be true while runtime is unconfirmed"
    }
  } finally {
    if (Test-Path -LiteralPath $temp) {
      Remove-Item -LiteralPath $temp -Recurse -Force
    }
  }
}

if (-not (Test-Path -LiteralPath $DistPath -PathType Container)) {
  Fail "dist directory does not exist: $DistPath"
}

$version = Get-PamVersion
$zipPath = Join-Path $DistPath "pam-core-$version.zip"
$tarPath = Join-Path $DistPath "pam-core-$version.tar.gz"
$checksumPath = Join-Path $DistPath "CHECKSUMS.txt"

foreach ($path in @($zipPath, $tarPath, $checksumPath)) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Fail "Missing package artifact: $path"
  }
}

$zipEntries = Get-ZipEntries $zipPath
$tarEntries = Get-TarEntries $tarPath

foreach ($required in $RequiredPaths) {
  if (-not (Test-RequiredPath -Entries $zipEntries -Path $required)) {
    Fail "Zip package is missing required path: $required"
  }
  if (-not (Test-RequiredPath -Entries $tarEntries -Path $required)) {
    Fail "tar.gz package is missing required path: $required"
  }
}

Test-ForbiddenEntries -Entries $zipEntries
Test-ForbiddenEntries -Entries $tarEntries
Test-Manifest -ArchivePath $zipPath -Format "zip"
Test-Manifest -ArchivePath $tarPath -Format "tar.gz"

$checksumText = Get-Content -Raw -LiteralPath $checksumPath
foreach ($fileName in @("pam-core-$version.zip", "pam-core-$version.tar.gz")) {
  if ($checksumText -notmatch [regex]::Escape($fileName)) {
    Fail "CHECKSUMS.txt is missing $fileName"
  }
  $artifactPath = Join-Path $DistPath $fileName
  $expectedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $artifactPath).Hash.ToLowerInvariant()
  if ($checksumText -notmatch "(?m)^$expectedHash\s+\*?$([regex]::Escape($fileName))$") {
    Fail "CHECKSUMS.txt hash does not match $fileName"
  }
}

Write-Host "pam-core package validation passed: $DistPath"
