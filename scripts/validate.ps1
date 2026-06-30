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

function Get-ClassifiedBacktickNames {
  param([string]$Text)

  $names = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::Ordinal)
  $insideClassifiedListItem = $false

  foreach ($line in ($Text -split "`r?`n")) {
    if ($line -match '^\s*-\s*(Planned skills?|Planned skill candidates|Concepts / technologies(?:[^:]*)?|Existing governance docs):') {
      $insideClassifiedListItem = $true
      foreach ($reference in (Get-BacktickNames $line)) {
        [void]$names.Add($reference)
      }
      continue
    }

    if ($insideClassifiedListItem -and $line -match '^\s{2,}\S') {
      foreach ($reference in (Get-BacktickNames $line)) {
        [void]$names.Add($reference)
      }
      continue
    }

    $insideClassifiedListItem = $false
  }

  return $names
}

function Get-ClassifiedBacktickNamesByKind {
  param(
    [string]$Text,
    [string]$Kind
  )

  $names = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::Ordinal)
  $insideMatchingListItem = $false
  $plannedPattern = '^\s*-\s*(Planned skills?|Planned skill candidates):'
  $conceptPattern = '^\s*-\s*(Concepts / technologies(?:[^:]*)?):'
  $pattern = $plannedPattern
  if ($Kind -eq "Concept") {
    $pattern = $conceptPattern
  }

  foreach ($line in ($Text -split "`r?`n")) {
    if ($line -match $pattern) {
      $insideMatchingListItem = $true
      foreach ($reference in (Get-BacktickNames $line)) {
        [void]$names.Add($reference)
      }
      continue
    }

    if ($insideMatchingListItem -and $line -match '^\s{2,}\S') {
      foreach ($reference in (Get-BacktickNames $line)) {
        [void]$names.Add($reference)
      }
      continue
    }

    $insideMatchingListItem = $false
  }

  return $names
}

function Format-AuditList {
  param([string[]]$Values)

  if (-not $Values -or $Values.Count -eq 0) {
    return "- None"
  }

  return (($Values | Sort-Object -Unique | ForEach-Object { "- $_" }) -join "`n")
}

function Write-AuditReport {
  param(
    [string]$PluginRoot,
    [int]$PhysicalSkillCount,
    [int]$SkillsWithSkillMdCount,
    [string[]]$SkillsMissingSkillMd,
    [string[]]$DependencyRepresentedSkills,
    [string[]]$MissingReferences,
    [string[]]$PlannedReferences,
    [string[]]$ConceptReferences,
    [string[]]$InspectedFiles,
    [string]$ClaudeValidationStatus,
    [string[]]$InstallExcludedWarnings
  )

  $reportPath = Join-Path $PluginRoot "docs\audit-report.md"
  $generatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
  $lines = @(
    "# pam-core Audit Report",
    "",
    "- Generated at: $generatedAt",
    "- Validation status: passed",
    "- Claude validation status: $ClaudeValidationStatus",
    "",
    "## Skill Inventory",
    "",
    "- Physical skill directories: $PhysicalSkillCount",
    "- Skill directories with SKILL.md: $SkillsWithSkillMdCount",
    "- Skills represented in SKILL_DEPENDENCIES.md: $($DependencyRepresentedSkills.Count)",
    "",
    "## Skills Missing SKILL.md",
    "",
    (Format-AuditList $SkillsMissingSkillMd),
    "",
    "## Missing References",
    "",
    (Format-AuditList $MissingReferences),
    "",
    "## Accepted Planned Skills",
    "",
    (Format-AuditList $PlannedReferences),
    "",
    "## Accepted Concepts / Technologies",
    "",
    (Format-AuditList $ConceptReferences),
    "",
    "## Central Files Inspected",
    "",
    (Format-AuditList $InspectedFiles),
    "",
    "## Install-Excluded Directory Warnings",
    "",
    (Format-AuditList $InstallExcludedWarnings),
    "",
    "## Automatically Validated",
    "",
    "- Required root files exist.",
    "- Critical text files are UTF-8 without BOM.",
    "- Codex plugin manifest is valid and points to ./skills/.",
    "- Every physical skill directory has valid SKILL.md frontmatter.",
    "- Every SKILL.md contains required headings in the expected order.",
    "- Cooperates With references point to physical skills.",
    "- MODULES.md current Skills sections match physical skills.",
    "- Central backticked references are existing skills, planned skills, concepts / technologies, or known non-skill references.",
    "- SKILL_DEPENDENCIES.md operational table columns reference physical skills only.",
    "- Every physical skill is represented in SKILL_DEPENDENCIES.md.",
    "- Empty files are rejected.",
    "- Marketplace files are UTF-8 without BOM when present.",
    "- Claude integration validation passed."
  )

  $docsPath = Join-Path $PluginRoot "docs"
  if (-not (Test-Path -LiteralPath $docsPath)) {
    [void](New-Item -ItemType Directory -Path $docsPath)
  }

  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($reportPath, (($lines -join "`n") + "`n"), $utf8NoBom)
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
  "scripts\validate-claude.ps1",
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

$skillsMissingSkillMd = New-Object System.Collections.Generic.List[string]
$skillsWithSkillMdCount = 0
foreach ($skillDir in $skillDirs) {
  $skillPath = Join-Path $skillDir.FullName "SKILL.md"
  if (-not (Test-Path -LiteralPath $skillPath)) {
    $skillsMissingSkillMd.Add($skillDir.Name)
    throw "Missing SKILL.md in $($skillDir.FullName)"
  }
  $skillsWithSkillMdCount++
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
$plannedReferences = Get-ClassifiedBacktickNamesByKind $modulesText "Planned"
$conceptReferences = Get-ClassifiedBacktickNamesByKind $modulesText "Concept"
$plannedReferences = @($plannedReferences | Where-Object { -not $skillNames.Contains($_) })
$conceptReferences = @($conceptReferences | Where-Object { -not $skillNames.Contains($_) })
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
  "pam-core",
  "pydantic",
  "pytest",
  "typer",
  "uvicorn"
) | ForEach-Object { [void]$knownNonSkillReferences.Add($_) }

$docsToCheck = @(
  "MODULES.md",
  "SKILL_DEPENDENCIES.md",
  "QUALITY_GATES.md",
  "AGENTS.md",
  "CLAUDE.md",
  "PROJECT_PROFILES.md",
  "scripts\validate.ps1"
)
$missingReferences = New-Object System.Collections.Generic.List[string]
foreach ($relativePath in $docsToCheck) {
  $path = Join-Path $PluginRoot $relativePath
  $text = Get-Content -Raw -LiteralPath $path
  $classifiedNonSkills = Get-ClassifiedBacktickNames $text
  foreach ($reference in (Get-BacktickNames $text)) {
    if ($skillNames.Contains($reference) -or
        $knownNonSkillReferences.Contains($reference) -or
        $classifiedNonSkills.Contains($reference)) {
      continue
    }
    $missingReferences.Add("$relativePath -> $reference")
    throw "$relativePath references unclassified backticked name that looks like a skill but does not exist in skills/: $reference. Move it under Planned skills or Concepts / technologies, or add it to known non-skill references if it is a legitimate command, file, project, or technology."
  }
}

$skillDependenciesPath = Join-Path $PluginRoot "SKILL_DEPENDENCIES.md"
$skillDependenciesLines = Get-Content -LiteralPath $skillDependenciesPath
$tableHeaders = @()
$insideMarkdownTable = $false
foreach ($line in $skillDependenciesLines) {
  if ($line -match '^\|(.+)\|$') {
    $cells = @($line.Trim("|") -split "\|" | ForEach-Object { $_.Trim() })
    $isSeparator = $true
    foreach ($cell in $cells) {
      if ($cell -notmatch '^:?-{3,}:?$') {
        $isSeparator = $false
        break
      }
    }
    if ($isSeparator) {
      continue
    }

    if (-not $insideMarkdownTable) {
      $tableHeaders = $cells
      $insideMarkdownTable = $true
      continue
    }

    for ($i = 0; $i -lt $cells.Count; $i++) {
      $header = $tableHeaders[$i]
      if ($header -notin @("Skill", "Lead Skill", "Cooperates With")) {
        continue
      }

      foreach ($part in ($cells[$i] -split ",")) {
        $candidate = $part.Trim()
        if (-not $candidate) {
          continue
        }
        if (-not $skillNames.Contains($candidate)) {
          throw "SKILL_DEPENDENCIES.md table column '$header' references missing physical skill: $candidate"
        }
      }
    }
    continue
  }

  $insideMarkdownTable = $false
  $tableHeaders = @()
}

$skillDependenciesText = Get-Content -Raw -LiteralPath $skillDependenciesPath
$dependencyRepresentedSkills = New-Object System.Collections.Generic.List[string]
foreach ($skillName in $skillNames) {
  if ($skillDependenciesText -notmatch "(^|[^a-z0-9-])$([regex]::Escape($skillName))([^a-z0-9-]|$)") {
    throw "Physical skill is missing from SKILL_DEPENDENCIES.md: $skillName"
  }
  $dependencyRepresentedSkills.Add($skillName)
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
$installExcludedWarnings = New-Object System.Collections.Generic.List[string]
foreach ($dirName in $forbiddenDirs) {
  $matches = Get-ChildItem -LiteralPath $PluginRoot -Force -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq $dirName }
  foreach ($match in $matches) {
    $childCount = @(Get-ChildItem -LiteralPath $match.FullName -Force -Recurse -ErrorAction SilentlyContinue).Count
    $relativePath = $match.FullName
    if ($relativePath.StartsWith($PluginRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
      $relativePath = $relativePath.Substring($PluginRoot.Length).TrimStart("\", "/")
    }
    if ($childCount -eq 0) {
      $warning = "Install-excluded directory is empty: $relativePath. It will not be copied by install-windows.ps1; remove it manually if it is leftover local state."
      $installExcludedWarnings.Add($warning)
      Write-Warning $warning
    } else {
      $warning = "Install-excluded directory is present: $relativePath ($childCount item(s)). It will not be copied by install-windows.ps1; keep it only if it is intentional local state."
      $installExcludedWarnings.Add($warning)
      Write-Warning $warning
    }
  }
}

$claudeValidationPath = Join-Path $PluginRoot "scripts\validate-claude.ps1"
& $claudeValidationPath -PluginRoot $PluginRoot
$claudeValidationStatus = "passed"

$inspectedFiles = @(
  $criticalTextFiles +
  $docsToCheck +
  @(
    "skills\*\SKILL.md",
    "docs\INSTALL_CLAUDE.md",
    "docs\MULTI_AGENT_COMPATIBILITY.md"
  )
) | Sort-Object -Unique

Write-AuditReport `
  -PluginRoot $PluginRoot `
  -PhysicalSkillCount $skillDirs.Count `
  -SkillsWithSkillMdCount $skillsWithSkillMdCount `
  -SkillsMissingSkillMd @($skillsMissingSkillMd) `
  -DependencyRepresentedSkills @($dependencyRepresentedSkills) `
  -MissingReferences @($missingReferences) `
  -PlannedReferences @($plannedReferences) `
  -ConceptReferences @($conceptReferences) `
  -InspectedFiles @($inspectedFiles) `
  -ClaudeValidationStatus $claudeValidationStatus `
  -InstallExcludedWarnings @($installExcludedWarnings)

Write-Host "pam-core validation passed: $PluginRoot"
