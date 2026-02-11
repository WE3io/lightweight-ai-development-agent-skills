#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install canonical skills into tool-specific discovery paths.

Usage:
  scripts/install-skills.sh [--target <path>] [--scope repo|user|both] [--dry-run] [--skip-existing] [--overwrite]

Options:
  --target <path>  Target repository root (repo scope only). Defaults to current working directory.
  --scope <scope>  repo (default): install into repo-local paths under target root.
                   user: install into $HOME/.codex, .claude, .cursor, .gemini, .gemini/antigravity.
                   both: install into both repo and user targets.
  --dry-run        Print actions without copying files.
  --skip-existing  Do not copy into skill directories that already exist at the destination.
  --overwrite      Replace existing skill directories after confirmation.
  -h, --help       Show this help.

Behavior:
- Repo scope (default): installs into .codex/skills/, .claude/skills/, .cursor/skills/, .gemini/skills/
- User scope: installs into $HOME/.codex/skills/, .claude/skills/, .cursor/skills/, .gemini/skills/, .gemini/antigravity/skills/
- Only directories under ./skills/ that contain SKILL.md are installed.
- Creates missing target directories. Merge copy into skill directories with the same name.
- In --overwrite mode, backs up replaced directories to a temporary location first.
- Never deletes other files or directories.
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_SKILLS_DIR="${SOURCE_ROOT}/skills"

TARGET_ROOT="$(pwd)"
SCOPE="repo"
DRY_RUN=0
SKIP_EXISTING=0
OVERWRITE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      if [[ $# -lt 2 ]]; then
        echo "Error: --target requires a path." >&2
        usage
        exit 1
      fi
      TARGET_ROOT="$2"
      shift 2
      ;;
    --scope)
      if [[ $# -lt 2 ]]; then
        echo "Error: --scope requires repo, user, or both." >&2
        usage
        exit 1
      fi
      case "$2" in
        repo|user|both) SCOPE="$2" ;;
        *)
          echo "Error: --scope must be repo, user, or both." >&2
          usage
          exit 1
          ;;
      esac
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --skip-existing)
      SKIP_EXISTING=1
      shift
      ;;
    --overwrite)
      OVERWRITE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument '$1'." >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ${SKIP_EXISTING} -eq 1 && ${OVERWRITE} -eq 1 ]]; then
  echo "Error: --skip-existing and --overwrite cannot be used together." >&2
  exit 1
fi

if [[ ! -d "${SOURCE_SKILLS_DIR}" ]]; then
  echo "Error: source skills directory not found: ${SOURCE_SKILLS_DIR}" >&2
  exit 1
fi

SKILL_DIRS=()
for d in "${SOURCE_SKILLS_DIR}"/*/; do
  [[ -f "${d}SKILL.md" ]] && SKILL_DIRS+=("${d%/}")
done
if [[ ${#SKILL_DIRS[@]} -eq 0 ]]; then
  echo "Error: no skill directories with SKILL.md found in ${SOURCE_SKILLS_DIR}" >&2
  exit 1
fi
IFS=$'\n' SKILL_DIRS=($(printf '%s\n' "${SKILL_DIRS[@]}" | sort))
unset IFS

if [[ "${SCOPE}" == "user" || "${SCOPE}" == "both" ]]; then
  if [[ -z "${HOME:-}" ]]; then
    echo "Error: HOME must be set for user scope." >&2
    exit 1
  fi
fi

TARGET_ENTRIES=()
case "${SCOPE}" in
  repo)
    TARGET_ENTRIES=(
      "repo|${TARGET_ROOT}/.codex/skills"
      "repo|${TARGET_ROOT}/.claude/skills"
      "repo|${TARGET_ROOT}/.cursor/skills"
      "repo|${TARGET_ROOT}/.gemini/skills"
    )
    ;;
  user)
    TARGET_ENTRIES=(
      "user|${HOME}/.codex/skills"
      "user|${HOME}/.claude/skills"
      "user|${HOME}/.cursor/skills"
      "user|${HOME}/.gemini/skills"
      "user|${HOME}/.gemini/antigravity/skills"
    )
    ;;
  both)
    TARGET_ENTRIES=(
      "repo|${TARGET_ROOT}/.codex/skills"
      "repo|${TARGET_ROOT}/.claude/skills"
      "repo|${TARGET_ROOT}/.cursor/skills"
      "repo|${TARGET_ROOT}/.gemini/skills"
      "user|${HOME}/.codex/skills"
      "user|${HOME}/.claude/skills"
      "user|${HOME}/.cursor/skills"
      "user|${HOME}/.gemini/skills"
      "user|${HOME}/.gemini/antigravity/skills"
    )
    ;;
esac

DEDUPED_TARGET_ENTRIES=()
for entry in "${TARGET_ENTRIES[@]}"; do
  target_dir="${entry#*|}"
  seen=0
  for existing_entry in "${DEDUPED_TARGET_ENTRIES[@]}"; do
    if [[ "${existing_entry#*|}" == "${target_dir}" ]]; then
      seen=1
      break
    fi
  done
  if [[ ${seen} -eq 0 ]]; then
    DEDUPED_TARGET_ENTRIES+=("${entry}")
  fi
done
TARGET_ENTRIES=("${DEDUPED_TARGET_ENTRIES[@]}")

EXISTING_DESTINATIONS=()
for entry in "${TARGET_ENTRIES[@]}"; do
  target_dir="${entry#*|}"
  for skill_dir in "${SKILL_DIRS[@]}"; do
    skill_name="$(basename "${skill_dir}")"
    destination="${target_dir}/${skill_name}"
    if [[ -d "${destination}" ]]; then
      EXISTING_DESTINATIONS+=("${destination}")
    fi
  done
done

echo "Source: ${SOURCE_SKILLS_DIR}"
echo "Scope: ${SCOPE}"
echo "Target root: ${TARGET_ROOT}"
if [[ "${SCOPE}" == "user" || "${SCOPE}" == "both" ]]; then
  echo "User home: ${HOME}"
fi
if [[ ${DRY_RUN} -eq 1 ]]; then
  echo "Mode: dry-run"
fi

if [[ ${OVERWRITE} -eq 1 && ${#EXISTING_DESTINATIONS[@]} -gt 0 ]]; then
  echo "Overwrite requested. Existing skill directories that would be replaced:"
  for existing in "${EXISTING_DESTINATIONS[@]}"; do
    echo "  ${existing}"
  done
  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo "Would prompt for confirmation before replacing existing directories."
  else
    if [[ ! -t 0 ]]; then
      echo "Error: --overwrite requires an interactive terminal for confirmation." >&2
      exit 1
    fi
    read -r -p "Proceed with overwrite and backup? [y/N] " confirm
    if [[ "${confirm}" != "y" && "${confirm}" != "Y" ]]; then
      echo "Aborted."
      exit 1
    fi
  fi
fi

BACKUP_DIR=""
BACKUP_SCOPES=()  # Track which scopes we backed up (repo, user) for restore guidance
if [[ ${OVERWRITE} -eq 1 && ${#EXISTING_DESTINATIONS[@]} -gt 0 ]]; then
  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo "Would create backup directory with mktemp before overwrite."
  else
    tmp_base="${TMPDIR:-/tmp}"
    tmp_base="${tmp_base%/}"
    BACKUP_DIR="$(mktemp -d "${tmp_base}/skills-backup.XXXXXX")"
    echo "Backup directory: ${BACKUP_DIR}"
  fi
fi

for entry in "${TARGET_ENTRIES[@]}"; do
  target_scope="${entry%%|*}"
  target_dir="${entry#*|}"
  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo "Would ensure directory: ${target_dir}"
  else
    mkdir -p "${target_dir}"
  fi

  for skill_dir in "${SKILL_DIRS[@]}"; do
    skill_name="$(basename "${skill_dir}")"
    destination="${target_dir}/${skill_name}"

    if [[ ${DRY_RUN} -eq 1 ]]; then
      if [[ ${SKIP_EXISTING} -eq 1 && -d "${destination}" ]]; then
        echo "Would skip existing: ${destination}"
      else
        echo "Would copy: ${skill_dir} -> ${destination}"
      fi
    else
      if [[ ${SKIP_EXISTING} -eq 1 && -d "${destination}" ]]; then
        echo "Skipped existing: ${destination}"
        continue
      fi
      if [[ ${OVERWRITE} -eq 1 && -d "${destination}" ]]; then
        backup_prefix="${target_scope}"
        if [[ "${backup_prefix}" == "repo" ]]; then
          relative_target_dir="${target_dir#${TARGET_ROOT}/}"
        else
          relative_target_dir="${target_dir#${HOME}/}"
        fi
        relative_destination="${destination#${target_dir}/}"
        backup_target="${BACKUP_DIR}/${backup_prefix}/${relative_target_dir}/${relative_destination}"
        mkdir -p "$(dirname "${backup_target}")"
        cp -R "${destination}" "${backup_target}"
        rm -rf "${destination}"
        # Track scope for restore hint (avoid duplicates)
        [[ " ${BACKUP_SCOPES[*]} " != *" ${backup_prefix} "* ]] && BACKUP_SCOPES+=("${backup_prefix}")
      fi
      mkdir -p "${destination}"
      cp -R "${skill_dir}/." "${destination}/"
      echo "Installed: ${destination}"
    fi
  done
done

echo "Done."
if [[ -n "${BACKUP_DIR}" ]]; then
  echo "Restore command(s):"
  for scope in "${BACKUP_SCOPES[@]}"; do
    if [[ "${scope}" == "repo" ]]; then
      echo "  cp -R \"${BACKUP_DIR}/repo/.\" \"${TARGET_ROOT}/\""
    else
      echo "  cp -R \"${BACKUP_DIR}/user/.\" \"${HOME}/\""
    fi
  done
fi
