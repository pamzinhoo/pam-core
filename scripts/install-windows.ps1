param(
  [string]$PluginName = "pam-core",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$source = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$pluginsRoot = Join-Path $HOME "plugins"
$target = Join-Path $pluginsRoot $PluginName
$marketplaceDir = Join-Path $HOME ".agents\plugins"
$marketplacePath = Join-Path $marketplaceDir "marketplace.json"
$excludedDirs = @(".git", ".agents", ".codex", ".cache", ".tmp", "node_modules", "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache")
$excludedFilePatterns = @("*.tmp", "*.temp", "*.log", "*.pyc", "*.pyo", "*.swp", "*.swo", "*~")
$criticalRootFiles = @(
  "AGENTS.md",
  "README.md",
  "MODULES.md",
  "SKILL_GUIDELINES.md",
  "SKILL_DEPENDENCIES.md",
  "PROJECT_PROFILES.md",
  "QUALITY_GATES.md",
  "PROJECT_STATE.md"
)

function Get-FullPath {
  param([string]$Path)

  return [System.IO.Path]::GetFullPath($Path).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
}

function Get-RelativePath {
  param(
    [string]$BasePath,
    [string]$Path
  )

  $baseFullPath = Get-FullPath $BasePath
  $pathFullPath = Get-FullPath $Path
  $baseUri = New-Object System.Uri(($baseFullPath + [System.IO.Path]::DirectorySeparatorChar))
  $pathUri = New-Object System.Uri($pathFullPath)
  $relativeUri = $baseUri.MakeRelativeUri($pathUri)
  return [System.Uri]::UnescapeDataString($relativeUri.ToString()).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
}

function Test-ExcludedPath {
  param([System.IO.FileSystemInfo]$Item)

  $relativePath = Get-RelativePath $source $Item.FullName
  $parts = $relativePath -split '[\\/]'
  foreach ($part in $parts) {
    if ($excludedDirs -contains $part) {
      return $true
    }
  }

  if (-not $Item.PSIsContainer) {
    foreach ($pattern in $excludedFilePatterns) {
      if ($Item.Name -like $pattern) {
        return $true
      }
    }
  }

  return $false
}

New-Item -ItemType Directory -Force -Path $pluginsRoot | Out-Null
New-Item -ItemType Directory -Force -Path $marketplaceDir | Out-Null

$resolvedSource = Get-FullPath $source
$resolvedTarget = if (Test-Path $target) { Get-FullPath (Resolve-Path $target).Path } else { Get-FullPath $target }
if ([string]::Equals($resolvedSource, $resolvedTarget, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Source and target are the same path: $source. Refusing to overwrite the plugin in place."
}

foreach ($criticalFile in $criticalRootFiles) {
  $sourcePath = Join-Path $source $criticalFile
  if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "Missing critical package file in source: $sourcePath"
  }
}

if ((Test-Path $target) -and -not $Force) {
  throw "Target already exists: $target. Re-run with -Force to replace it."
}

if (Test-Path $target) {
  Remove-Item -Recurse -Force -LiteralPath $target
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

Get-ChildItem -LiteralPath $source -Recurse -Force | ForEach-Object {
  if (Test-ExcludedPath $_) {
    return
  }

  $relativePath = Get-RelativePath $source $_.FullName
  $destination = Join-Path $target $relativePath
  if ($_.PSIsContainer) {
    New-Item -ItemType Directory -Force -Path $destination | Out-Null
  } else {
    $destinationDir = Split-Path -Parent $destination
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
    Copy-Item -Force -LiteralPath $_.FullName -Destination $destination
  }
}

foreach ($criticalFile in $criticalRootFiles) {
  $targetPath = Join-Path $target $criticalFile
  if (-not (Test-Path -LiteralPath $targetPath)) {
    throw "Missing critical package file in installed copy: $targetPath"
  }
}

if (Test-Path $marketplacePath) {
  $marketplace = Get-Content -Raw -LiteralPath $marketplacePath | ConvertFrom-Json
} else {
  $marketplace = [ordered]@{
    name = "personal"
    interface = [ordered]@{ displayName = "Personal" }
    plugins = @()
  }
}

if (-not $marketplace.name) {
  $marketplace | Add-Member -NotePropertyName name -NotePropertyValue "personal"
}
if (-not $marketplace.interface) {
  $marketplace | Add-Member -NotePropertyName interface -NotePropertyValue ([ordered]@{ displayName = "Personal" })
}
if ($null -eq $marketplace.plugins) {
  $marketplace | Add-Member -NotePropertyName plugins -NotePropertyValue @()
}

$entry = [ordered]@{
  name = $PluginName
  source = [ordered]@{
    source = "local"
    path = "./plugins/$PluginName"
  }
  policy = [ordered]@{
    installation = "AVAILABLE"
    authentication = "ON_INSTALL"
  }
  category = "Productivity"
}

$plugins = @($marketplace.plugins | Where-Object { $_.name -ne $PluginName })
$marketplace.plugins = @($plugins + $entry)

$json = $marketplace | ConvertTo-Json -Depth 10
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($marketplacePath, $json + [Environment]::NewLine, $utf8NoBom)

Write-Host "Installed local plugin source to $target"
Write-Host "Updated marketplace at $marketplacePath"
Write-Host "Next: codex.cmd plugin add $PluginName@$($marketplace.name)"
