param(
  [string]$PluginName = "pam-core",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$pluginsRoot = Join-Path $HOME "plugins"
$target = Join-Path $pluginsRoot $PluginName
$marketplacePath = Join-Path (Join-Path $HOME ".agents\plugins") "marketplace.json"

function Get-FullPath {
  param([string]$Path)

  return [System.IO.Path]::GetFullPath($Path).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
}

$resolvedPluginsRoot = Get-FullPath $pluginsRoot
$resolvedTarget = if (Test-Path -LiteralPath $target) { Get-FullPath (Resolve-Path -LiteralPath $target).Path } else { Get-FullPath $target }

if (-not $Force) {
  throw "Re-run with -Force to remove the local plugin source and marketplace entry."
}

if (-not $resolvedTarget.StartsWith($resolvedPluginsRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to uninstall outside plugins directory: $resolvedTarget"
}

if (Test-Path -LiteralPath $target) {
  Remove-Item -Recurse -Force -LiteralPath $target
  Write-Host "Removed plugin source at $target"
} else {
  Write-Host "Plugin source not found at $target"
}

if (Test-Path -LiteralPath $marketplacePath) {
  $marketplace = Get-Content -Raw -LiteralPath $marketplacePath | ConvertFrom-Json
  if ($null -ne $marketplace.plugins) {
    $marketplace.plugins = @($marketplace.plugins | Where-Object { $_.name -ne $PluginName })
    $json = $marketplace | ConvertTo-Json -Depth 10
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($marketplacePath, $json + [Environment]::NewLine, $utf8NoBom)
    Write-Host "Removed $PluginName from marketplace at $marketplacePath"
  } else {
    Write-Host "Marketplace has no plugins list: $marketplacePath"
  }
} else {
  Write-Host "Marketplace not found at $marketplacePath"
}
