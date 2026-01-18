## Quick Start 1: Greenfield Project

**Scenario:**  
You’ve just created an empty repo for a new internal service. There’s no structure yet.

### Step 1: Turn an idea into a work item
You have a vague request:
> “We need a simple todo app so we can validate the flow.”

You invoke **Work Item Designer** with that intent.

What happens:
- It asks a couple of clarifying questions.
- It produces a clear work item with:
  - Outcome (basic CRUD for todos),
  - Constraints (local-only, no auth),
  - Acceptance checks (create, list, complete, delete),
  - Non-goals (no persistence, no UI polish).

It proposes:
> “There’s no backlog structure. Shall I create `/backlog/active/` and save this as a file?”

You say yes.

Result:
- First real artefact exists.
- No process overhead introduced.

---

### Step 2: Sanity-check before building
You glance at the item and think:
> “This is small, but I don’t want surprises.”

You run **Safety Lens** on the work item.

Result:
- “No significant risk detected.”

That’s a valid outcome. You move on.

---

### Step 3: Implement
You invoke **Implementation Executor** on the backlog item.

What happens:
- It restates scope and non-goals.
- It implements exactly what’s required.
- It runs acceptance checks.
- It updates the backlog item with a short “Completed” note.

No refactors. No extras.

---

### Step 4: Sense-check for decisions
After reviewing the diff, you wonder:
> “Did we accidentally lock in anything here?”

You run **Decision Lens** on the changes.

Result:
- “No decision signal detected.”

You don’t write an ADR. That’s fine.

---

### Step 5: Documentation (optional)
You didn’t introduce new concepts or constraints, so you skip **Documentation Lens**.

**Outcome:**
- Working code.
- A clear record of what was built.
- No unnecessary docs.

---

## Quick Start 2: Legacy Project

**Scenario:**  
You’re working in a large, older repo with unclear conventions and historical decisions.

### Step 1: Shape a risky request
You’re asked:
> “Can we change how user IDs are generated?”

You invoke **Work Item Designer**.

What happens:
- It inspects the repo.
- It notices there’s no formal backlog, but there *are* task notes in `/docs/notes/`.
- It aligns to existing conventions instead of creating new ones.
- It produces a clear work item and asks before persisting anything.

You approve.

---

### Step 2: Pre-flight risk check
This feels risky.

You run **Safety Lens**.

It surfaces:
- “This change affects persistent identifiers and may break downstream systems.”

You confirm:
> “Yes, we understand the risk — continue.”

Safety Lens steps aside.

---

### Step 3: Build carefully
You invoke **Implementation Executor**.

What happens:
- It restates non-goals clearly (no schema migration yet).
- It implements the change in the narrowest possible way.
- It avoids touching unrelated areas.
- It records completion using the repo’s existing conventions.

---

### Step 4: Catch a real decision
Before merging, you run **Decision Lens**.

It flags:
- “This change constrains future ID formats and migration options.”

You decide:
> “Yes, this is a real decision.”

You ask it to draft an ADR stub.
- You keep it.
- It lives alongside existing decision docs.
- Nothing else changes.

---

### Step 5: Documentation alignment
There’s a doc explaining user IDs in three places.

You run **Documentation Lens**.

It suggests:
- linking to one canonical explanation,
- trimming duplication.

You agree and make a small edit.

---

**Outcome:**
- The change is intentional, not accidental.
- Risk was surfaced and consciously accepted.
- Legacy conventions were respected.
- You left behind just enough history for the next person.