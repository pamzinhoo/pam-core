param(
  [string]$PluginRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

function Test-HasBom {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return $false
  }

  $bytes = [System.IO.File]::ReadAllBytes($Path)
  return $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
}

function Get-BacktickNames {
  param([string]$Text)

  $names = New-Object System.Collections.Generic.List[string]
  foreach ($match in [regex]::Matches($Text, '`([a-z][a-z0-9-]+)`')) {
    $names.Add($match.Groups[1].Value)
  }
  return $names
}

function Get-SectionText {
  param(
    [string]$Text,
    [string]$Heading
  )

  $escapedHeading = [regex]::Escape($Heading)
  $match = [regex]::Match($Text, "(?ms)^## $escapedHeading\s*(.*?)(?=^## |\z)")
  if ($match.Success) {
    return $match.Groups[1].Value
  }
  return ""
}

function Get-CooperationNames {
  param([string]$Text)

  $names = New-Object System.Collections.Generic.List[string]
  $normalized = $Text.Replace('`', '')
  foreach ($part in ($normalized -split '[,\r\n]+')) {
    $candidate = ($part.Trim() -replace '^[.;\s]+|[.;\s]+$', '')
    if ($candidate -match '^[a-z][a-z0-9-]+$') {
      $names.Add($candidate)
    }
  }
  return $names
}

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
$requiredFiles = @(
  $criticalRootFiles +
  "CHANGELOG.md"
)
foreach ($requiredFile in $requiredFiles) {
  $path = Join-Path $PluginRoot $requiredFile
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing required file: $path"
  }
}

$criticalTextFiles = @(
  ".codex-plugin\plugin.json",
  "AGENTS.md",
  "README.md",
  "MODULES.md",
  "SKILL_GUIDELINES.md",
  "SKILL_DEPENDENCIES.md",
  "PROJECT_PROFILES.md",
  "QUALITY_GATES.md",
  "PROJECT_STATE.md",
  "DECISIONS.md",
  "VERSIONING.md",
  "CONTRIBUTING.md",
  "CHANGELOG.md",
  "scripts\install-windows.ps1",
  "scripts\uninstall-windows.ps1",
  "scripts\validate.ps1"
)
foreach ($relativePath in $criticalTextFiles) {
  $path = Join-Path $PluginRoot $relativePath
  if (Test-HasBom $path) {
    throw "Critical file must be UTF-8 without BOM: $path"
  }
}

$manifestPath = Join-Path $PluginRoot ".codex-plugin\plugin.json"
if (-not (Test-Path -LiteralPath $manifestPath)) {
  throw "Missing manifest: $manifestPath"
}

try {
  $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
} catch {
  throw "plugin.json is not valid JSON: $manifestPath"
}

if ($manifest.name -ne "pam-core") {
  throw "plugin.json name must be pam-core"
}
if ($manifest.version -notmatch '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$') {
  throw "plugin.json version must be semver"
}
if (-not $manifest.description) {
  throw "plugin.json description is required"
}
if (-not $manifest.author.name) {
  throw "plugin.json author.name is required"
}
if ($manifest.skills -ne "./skills/") {
  throw "plugin.json skills must be ./skills/"
}
if (-not $manifest.interface.displayName -or -not $manifest.interface.shortDescription -or -not $manifest.interface.longDescription) {
  throw "plugin.json interface descriptions are required"
}
if (-not $manifest.interface.defaultPrompt -or @($manifest.interface.defaultPrompt).Count -gt 3) {
  throw "plugin.json interface.defaultPrompt must contain 1 to 3 prompts"
}

$skillsRoot = Join-Path $PluginRoot "skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) {
  throw "Missing skills directory: $skillsRoot"
}

$requiredHeadings = @(
  "Purpose",
  "Auto Activation",
  "Do Not Activate",
  "Detect",
  "Responsibilities",
  "Never Do",
  "Cooperates With",
  "Final Checklist",
  "Examples"
)

$skillDirs = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
if ($skillDirs.Count -eq 0) {
  throw "No skills found in $skillsRoot"
}

$skillNames = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::Ordinal)
foreach ($skillDir in $skillDirs) {
  if ($skillDir.Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
    throw "Skill directory name must be lowercase hyphenated: $($skillDir.Name)"
  }
  [void]$skillNames.Add($skillDir.Name)
}

foreach ($skillDir in $skillDirs) {
  $skillPath = Join-Path $skillDir.FullName "SKILL.md"
  if (-not (Test-Path -LiteralPath $skillPath)) {
    throw "Missing SKILL.md in $($skillDir.FullName)"
  }
  if (Test-HasBom $skillPath) {
    throw "SKILL.md must be UTF-8 without BOM: $skillPath"
  }

  $content = Get-Content -Raw -LiteralPath $skillPath
  if ($content -notmatch '^---\r?\n') {
    throw "$skillPath must start with YAML frontmatter"
  }
  $frontmatterMatch = [regex]::Match($content, "(?ms)^---\r?\n(.*?)\r?\n---")
  if (-not $frontmatterMatch.Success) {
    throw "$skillPath must contain closed YAML frontmatter"
  }
  $nameMatch = [regex]::Match($frontmatterMatch.Groups[1].Value, "(?m)^name:\s*(\S+)\s*$")
  if (-not $nameMatch.Success) {
    throw "$skillPath is missing frontmatter name"
  }
  if ($nameMatch.Groups[1].Value -ne $skillDir.Name) {
    throw "$skillPath frontmatter name must match directory name"
  }
  if ($frontmatterMatch.Groups[1].Value -notmatch "(?m)^description:\s*\S+") {
    throw "$skillPath is missing frontmatter description"
  }

  $headings = @([regex]::Matches($content, '(?m)^##\s+(.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() })
  foreach ($heading in $requiredHeadings) {
    if ($heading -notin $headings) {
      throw "$skillPath is missing required heading: $heading"
    }
  }

  $headingPositions = @{}
  for ($i = 0; $i -lt $headings.Count; $i++) {
    if (-not $headingPositions.ContainsKey($headings[$i])) {
      $headingPositions[$headings[$i]] = $i
    }
  }
  for ($i = 0; $i -lt $requiredHeadings.Count; $i++) {
    if ($headingPositions[$requiredHeadings[$i]] -ne $i) {
      throw "$skillPath required headings must follow SKILL_GUIDELINES.md order"
    }
  }

  $cooperatesWith = Get-SectionText $content "Cooperates With"
  foreach ($reference in (Get-CooperationNames $cooperatesWith)) {
    if (-not $skillNames.Contains($reference)) {
      throw "$skillPath references missing skill in Cooperates With: $reference"
    }
  }
}

$modulesPath = Join-Path $PluginRoot "MODULES.md"
$modulesText = Get-Content -Raw -LiteralPath $modulesPath
$moduleSkillNames = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::Ordinal)
$insideSkillsSection = $false
foreach ($line in ($modulesText -split "`r?`n")) {
  if ($line -match '^### Skills\s*$') {
    $insideSkillsSection = $true
    continue
  }
  if ($insideSkillsSection -and $line -match '^### ') {
    $insideSkillsSection = $false
  }
  if ($insideSkillsSection) {
    foreach ($reference in (Get-BacktickNames $line)) {
      [void]$moduleSkillNames.Add($reference)
    }
  }
}

foreach ($moduleSkill in $moduleSkillNames) {
  if (-not $skillNames.Contains($moduleSkill)) {
    throw "MODULES.md lists missing physical skill in current Skills sections: $moduleSkill"
  }
}
foreach ($skillName in $skillNames) {
  if (-not $moduleSkillNames.Contains($skillName)) {
    throw "Physical skill is missing from MODULES.md current Skills sections: $skillName"
  }
}

$knownNonSkillReferences = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::Ordinal)
@(
  "argparse",
  "click",
  "pydantic",
  "pytest",
  "typer",
  "uvicorn"
) | ForEach-Object { [void]$knownNonSkillReferences.Add($_) }

$docsToCheck = @(
  "SKILL_DEPENDENCIES.md",
  "PROJECT_PROFILES.md",
  "QUALITY_GATES.md"
)
foreach ($relativePath in $docsToCheck) {
  $path = Join-Path $PluginRoot $relativePath
  $text = Get-Content -Raw -LiteralPath $path
  foreach ($reference in (Get-BacktickNames $text)) {
    if ($skillNames.Contains($reference) -or $knownNonSkillReferences.Contains($reference)) {
      continue
    }
    throw "$relativePath references missing skill or unknown backticked name: $reference"
  }
}

$emptyFiles = Get-ChildItem -LiteralPath $PluginRoot -Force -Recurse -File |
  Where-Object { $_.Length -eq 0 }
if ($emptyFiles) {
  throw "Empty files found: $(@($emptyFiles | Select-Object -ExpandProperty FullName) -join ', ')"
}

$marketplacePaths = @(
  (Join-Path $PluginRoot "marketplace.json"),
  (Join-Path $PluginRoot ".agents\plugins\marketplace.json")
)
foreach ($marketplacePath in $marketplacePaths) {
  if (Test-HasBom $marketplacePath) {
    throw "marketplace.json must be UTF-8 without BOM: $marketplacePath"
  }
}

$forbiddenDirs = @(".git", ".agents", ".codex", ".cache", ".tmp", "node_modules", "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache")
foreach ($dirName in $forbiddenDirs) {
  $matches = Get-ChildItem -LiteralPath $PluginRoot -Force -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq $dirName }
  if ($matches) {
    Write-Warning "Install-excluded directory present in source tree: $dirName"
  }
}

Write-Host "pam-core validation passed: $PluginRoot"
