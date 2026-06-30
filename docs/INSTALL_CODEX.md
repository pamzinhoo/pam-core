# Install pam-core for Codex

Codex remains the primary supported adapter for `pam-core` version `1.2.0`.

## Validate

From the repository root:

```powershell
.\scripts\validate.ps1
```

If PowerShell blocks local scripts:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

## Install

From the repository root:

```powershell
.\scripts\install-windows.ps1
codex.cmd plugin add pam-core@personal
```

To replace an existing local plugin copy:

```powershell
.\scripts\install-windows.ps1 -Force
codex.cmd plugin add pam-core@personal
```

Start a new Codex thread after installing so the CLI reloads plugin skills.

## Check Codex State

Use Codex commands to inspect plugin state:

```powershell
codex.cmd plugin list
codex.cmd --version
```

The expected Codex CLI version for this release is documented in `README.md`.

## Notes

The installer copies this repository to `%USERPROFILE%\plugins\pam-core` and
updates `%USERPROFILE%\.agents\plugins\marketplace.json`. It excludes `.git`,
`.agents`, `.codex`, caches, `node_modules`, and temporary files from the local
plugin copy.

Do not reinstall the plugin unless explicitly approved.
