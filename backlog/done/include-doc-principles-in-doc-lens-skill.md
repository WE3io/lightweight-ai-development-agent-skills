# Include documentation-principles.md in documentation-lens skill install

## 1. Outcome

- `documentation-principles.md` lives in `skills/documentation-lens/` and is installed with the documentation-lens skill.
- The reference in `SKILL.md` resolves correctly when the skill is installed.
- `README.md` references the new location of `documentation-principles.md`.

## 2. Constraints & References

- Do not modify `scripts/install-skills.sh`; it already copies each skill directory as-is.
- The install script uses `cp -R "${skill_dir}/." "${destination}/"`; only files inside `skills/documentation-lens/` are installed.
- Reference: `documentation-principles.md` (repo root) and `README.md` line 103.

## 3. Acceptance Checks

- [x] `documentation-principles.md` exists at `skills/documentation-lens/documentation-principles.md`.
- [x] `documentation-principles.md` no longer exists at repo root.
- [x] `README.md` references `skills/documentation-lens/documentation-principles.md` instead of `documentation-principles.md`.
- [x] `SKILL.md` reference to `documentation-principles.md` is unchanged.
- [x] Running `scripts/install-skills.sh --scope repo --dry-run` shows both `SKILL.md` and `documentation-principles.md` would be copied from `skills/documentation-lens/`.
- [x] After a fresh install, `documentation-principles.md` is present alongside `SKILL.md` in the destination (e.g. `.cursor/skills/documentation-lens/`).

## 4. Explicit Non-Goals

- Changing the install script to support external-file manifests or per-skill override logic.
- Modifying the content of `documentation-principles.md`.
- Addressing other skills that reference external files.
- Introducing symlinks or build/sync steps.

---

**Completed.** Moved `documentation-principles.md` into `skills/documentation-lens/`, updated `README.md` reference, verified install. All acceptance checks pass.
