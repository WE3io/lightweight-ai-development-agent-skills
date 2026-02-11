# Add ~/.cursor/skills/ to user-scope install targets

## 1. Outcome

- `scripts/install-skills.sh --scope user` installs skills into `~/.cursor/skills/`.
- `scripts/install-skills.sh --scope both` installs skills into `~/.cursor/skills/` when user scope is included.
- Script help text and `INSTALLATION.md` reflect Cursor's user-level path.
- Smoke tests pass (including the new target).

## 2. Constraints & References

- Align with Cursor docs: https://cursor.com/docs/context/skills — `~/.cursor/skills/` is a user-level discovery path.
- Add `~/.cursor/skills/` to user-scope targets in the same pattern as `~/.codex/skills/` and `~/.claude/skills/`.
- Use `${HOME}` for the user home path.

## 3. Acceptance Checks

- [x] `scripts/install-skills.sh --scope user --dry-run` includes `$HOME/.cursor/skills`.
- [x] `scripts/install-skills.sh --scope user` installs skills to `~/.cursor/skills/`.
- [x] Script help text lists `.cursor/skills/` in user scope description and removes the incorrect "Cursor has no user-scoped target" note.
- [x] `INSTALLATION.md` lists `~/.cursor/skills/` among user-scoped install targets.
- [x] `scripts/test-install-skills.sh` passes.
- [x] User-scope target count in tests reflects the new Cursor target (5 user targets instead of 4).

## 4. Explicit Non-Goals

- Changing repo-scope behavior.
- Changing Gemini or other tool targets.
- Verifying Cursor discovery behavior in the IDE (assume docs are correct).
- Modifying .gitignore or other repository configuration.

---

**Completed.** Added `~/.cursor/skills/` to user-scope targets in install-skills.sh, updated help text and INSTALLATION.md, set USER_TARGET_COUNT=5 and added cursor path assertion in test-install-skills.sh. Replaced `rg` with `grep` in tests for portability. All acceptance checks pass.
