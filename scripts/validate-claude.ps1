param(
  [string]$PluginRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

function Test-RequiredFile {
  param(
    [string]$Root,
    [string]$RelativePath
  )

  $path = Join-Path $Root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    throw "Missing required file: $path"
  }
  return $path
}

function Test-RequiredDirectory {
  param(
    [string]$Root,
    [string]$RelativePath
  )

  $path = Join-Path $Root $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    throw "Missing required directory: $path"
  }
  return $path
}

$claudePath = Test-RequiredFile $PluginRoot "CLAUDE.md"
$manifestPath = Test-RequiredFile $PluginRoot ".claude-plugin\plugin.json"
[void](Test-RequiredFile $PluginRoot "docs\INSTALL_CLAUDE.md")
[void](Test-RequiredFile $PluginRoot "docs\MULTI_AGENT_COMPATIBILITY.md")

try {
  $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
} catch {
  throw ".claude-plugin/plugin.json is not valid JSON: $manifestPath"
}

if ($manifest.name -ne "pam-core") {
  throw ".claude-plugin/plugin.json name must be pam-core"
}
if ($manifest.skills -ne "./skills/") {
  throw ".claude-plugin/plugin.json skills must point to ./skills/"
}

$rootSkillDirs = @(Get-ChildItem -LiteralPath $PluginRoot -Force -Directory |
  Where-Object { $_.Name -ieq "skills" })
if ($rootSkillDirs.Count -ne 1) {
  throw "Expected exactly one root skills directory, found $($rootSkillDirs.Count)"
}

$skillsRoot = Test-RequiredDirectory $PluginRoot "skills"
$claudeSkillsPath = Join-Path $PluginRoot ".claude\skills"
if (Test-Path -LiteralPath $claudeSkillsPath) {
  throw "Claude-specific duplicate skills directory is not allowed: $claudeSkillsPath"
}

$skillDirs = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
if ($skillDirs.Count -eq 0) {
  throw "No skills found in $skillsRoot"
}

foreach ($skillDir in $skillDirs) {
  $skillPath = Join-Path $skillDir.FullName "SKILL.md"
  if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
    throw "Missing SKILL.md in $($skillDir.FullName)"
  }
}

$claudeText = Get-Content -Raw -LiteralPath $claudePath
$requiredCoreReferences = @(
  "pam-core",
  "skills/",
  "MODULES.md",
  "SKILL_DEPENDENCIES.md",
  "PROJECT_PROFILES.md",
  "QUALITY_GATES.md",
  "SKILL_GUIDELINES.md",
  "PROJECT_STATE.md",
  "AGENTS.md"
)
foreach ($reference in $requiredCoreReferences) {
  if ($claudeText -notlike "*$reference*") {
    throw "CLAUDE.md must reference shared pam-core core item: $reference"
  }
}

Write-Host "pam-core Claude validation passed: $PluginRoot"
