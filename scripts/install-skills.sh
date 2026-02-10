#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install canonical skills into tool-specific discovery paths.

Usage:
  scripts/install-skills.sh [--target <path>] [--dry-run] [--skip-existing] [--overwrite]

Options:
  --target <path>  Target repository root to install into. Defaults to current working directory.
  --dry-run        Print actions without copying files.
  --skip-existing  Do not copy into skill directories that already exist at the destination.
  --overwrite      Replace existing skill directories after confirmation.
  -h, --help       Show this help.

Behavior:
- Copies each directory under ./skills into:
  .claude/skills/
  .agents/skills/
  .cursor/skills/
  .gemini/skills/
- Creates missing target directories.
- Copies into skill directories with the same name (merge copy).
- In --overwrite mode, backs up replaced directories to a temporary location first.
- Never deletes other files or directories.
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_SKILLS_DIR="${SOURCE_ROOT}/skills"

TARGET_ROOT="$(pwd)"
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

mapfile -t SKILL_DIRS < <(find "${SOURCE_SKILLS_DIR}" -mindepth 1 -maxdepth 1 -type d | sort)
if [[ ${#SKILL_DIRS[@]} -eq 0 ]]; then
  echo "Error: no skill directories found in ${SOURCE_SKILLS_DIR}" >&2
  exit 1
fi

TARGET_PATHS=(
  "${TARGET_ROOT}/.claude/skills"
  "${TARGET_ROOT}/.agents/skills"
  "${TARGET_ROOT}/.cursor/skills"
  "${TARGET_ROOT}/.gemini/skills"
)

EXISTING_DESTINATIONS=()
for target_dir in "${TARGET_PATHS[@]}"; do
  for skill_dir in "${SKILL_DIRS[@]}"; do
    skill_name="$(basename "${skill_dir}")"
    destination="${target_dir}/${skill_name}"
    if [[ -d "${destination}" ]]; then
      EXISTING_DESTINATIONS+=("${destination}")
    fi
  done
done

echo "Source: ${SOURCE_SKILLS_DIR}"
echo "Target root: ${TARGET_ROOT}"
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

for target_dir in "${TARGET_PATHS[@]}"; do
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
        relative_destination="${destination#"${TARGET_ROOT}/"}"
        backup_target="${BACKUP_DIR}/${relative_destination}"
        mkdir -p "$(dirname "${backup_target}")"
        cp -R "${destination}" "${backup_target}"
        rm -rf "${destination}"
      fi
      mkdir -p "${destination}"
      cp -R "${skill_dir}/." "${destination}/"
      echo "Installed: ${destination}"
    fi
  done
done

echo "Done."
if [[ -n "${BACKUP_DIR}" ]]; then
  echo "Restore command:"
  echo "cp -R \"${BACKUP_DIR}/.\" \"${TARGET_ROOT}/\""
fi
