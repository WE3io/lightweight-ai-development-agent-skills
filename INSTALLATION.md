# Installation Guide

This repository stores five canonical skills in `skills/` and mirrors them into tool-specific discovery paths.

## Canonical source

- `skills/` is the only source of truth.
- Each skill lives in its own directory with `SKILL.md`.
- Do not edit mirrored copies directly.

## Tool discovery paths

Mirror `skills/` into these repo-scoped paths:

- `.claude/skills/`
- `.agents/skills/`
- `.cursor/skills/`
- `.gemini/skills/`

## Deployment skill (manual invocation)

Use deployment deliberately as an operational skill:

1. Read from `skills/`.
2. Copy each skill directory into each discovery path.
3. Preserve directory names exactly.
4. Do not use symlinks.
5. Do not delete or mutate files that were not created by this mirror operation.

This deployment approach is intentionally not automated.

## Scripted install (manual command)

Run from this repository:

```bash
scripts/install-skills.sh --target /path/to/target-repo
```

Optional:
- `--dry-run` previews target paths and copy actions.
- `--skip-existing` avoids writing into existing skill directories.
- `--overwrite` replaces existing skill directories only after an interactive confirmation prompt.

## Overwrite backups and restore

When `--overwrite` is used and existing skill directories are present:

- The script prompts for confirmation before replacing anything.
- Existing skill directories are backed up to a temporary directory.
- The script prints a one-line restore command at the end, for example:

```bash
cp -R "/tmp/skills-backup.xxxxxx/." "/path/to/target-repo/"
```
