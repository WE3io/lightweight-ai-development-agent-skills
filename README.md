# Lightweight AI Development Agent Skills

This repository contains a small, reusable set of **AI agent skills** designed to support disciplined, low-ceremony software development.

These skills are **not a framework**, **not a workflow**, and **not a ticketing system**.  
They are portable, team-level behaviours that help humans and AI assistants work together safely and effectively in real codebases.

They’ve been designed and exercised across:
- solo developers and distributed teams,
- greenfield projects and legacy systems,
- exploratory work and production changes.

---

## Canonical skill source

The canonical source of truth is the `skills/` directory:

```text
skills/
  work-item-designer/
    SKILL.md
  implementation-executor/
    SKILL.md
  decision-lens/
    SKILL.md
  documentation-lens/
    SKILL.md
  safety-lens/
    SKILL.md
```

Each directory maps one-to-one to the five roles below.  
Tool-specific directories are mirrors created from this source; they are not edited directly.

---

## Why this exists

AI assistants are fast, tireless, and increasingly capable — but without constraints they tend to:
- guess when requirements are unclear,
- expand scope opportunistically,
- introduce accidental architectural decisions,
- and create documentation sprawl.

This repo provides **five narrowly scoped skills** that address those failure modes *without* introducing process overhead.

Each skill behaves like a **bounded professional role** you invoke at the right moment:
- to clarify work,
- to execute safely,
- to notice decisions early,
- to keep documentation coherent,
- or to pause when something looks risky.

Humans remain in control at all times.

---

## The five skills

### 1. Work Item Designer
Turn vague requests into clear, executable work items with explicit:
- outcomes,
- constraints,
- acceptance checks,
- and non-goals.

Used during backlog intake, grooming, or whenever a request feels underspecified.

---

### 2. Implementation Executor
Execute **exactly one** well-formed work item:
- minimal changes,
- explicit verification,
- no scope creep,
- and a small, durable record that the work happened.

Used once the task is genuinely ready to build.

---

### 3. Decision Lens
Surface when work starts to lock in long-term choices:
- API shapes,
- data schemas,
- coupling,
- irreversible patterns.

It flags *decision-ness* without enforcing documentation or blocking progress.

---

### 4. Documentation Lens
Prevent documentation drift by:
- encouraging a single source of truth,
- preferring links over duplication,
- keeping docs lightweight and intentional,
- and applying the principle: *document to position the reader in the system, state only durable contracts, and include detail solely when its long-term value exceeds its maintenance cost*.

It reviews; it does not rewrite or enforce structure.

See `documentation-principles.md` for full documentation guidance.

---

### 5. Safety Lens
Detect ambiguity, risk, or large blast radius early:
- missing requirements,
- destructive operations,
- irreversible changes.

It pauses and asks for clarification instead of guessing.  
Humans can explicitly accept risk and move on.

---

## How the skills are meant to be used

Think of the skills as **specialist colleagues**, not automation.

A common (but optional) flow looks like this:

1. **Define the work**  
   Use *Work Item Designer* to shape a vague request.

2. **Check for risk**  
   Use *Safety Lens* if anything feels unclear or risky.

3. **Build**  
   Use *Implementation Executor* to make the change.

4. **Sense-check decisions**  
   Use *Decision Lens* if APIs, schemas, or architecture are touched.

5. **Handle docs**  
   Use *Documentation Lens* to avoid duplication or misplaced explanation.

You don’t have to use every skill every time.  
“No signal detected” is a perfectly good outcome.

---

## Persistence vs conversation (important)

Most skills operate in two modes:

- **Ephemeral (default)**  
  Think, explore, review.  
  Nothing is written unless you ask.

- **Persistent (opt-in)**  
  Backlog items, decision records, or docs are written deliberately.  
  Never automatic. Never surprising.

If you want something saved, say so.  
If you don’t, nothing will be created.

---

## Quick start: Greenfield project

**Scenario:** You’ve just created an empty repo for a new internal service.

### Step 1 — Shape the work
You have a vague request:

> “We need a simple todo app to validate the flow.”

Run **Work Item Designer**:
- It asks a couple of clarifying questions.
- Produces a clear work item (outcome, acceptance, non-goals).
- Proposes a minimal backlog structure and asks before creating it.

You agree → the first backlog item is written.

---

### Step 2 — Sanity check
You run **Safety Lens**.

Result:
> “No significant risk detected.”

That’s a normal, healthy outcome.

---

### Step 3 — Build
You run **Implementation Executor**:
- It implements exactly the described behaviour.
- Verifies acceptance checks.
- Records completion in the backlog item.

No refactors. No extras.

---

### Step 4 — Decision check
You run **Decision Lens** on the diff.

Result:
> “No decision signal detected.”

You don’t write an ADR. That’s fine.

---

### Step 5 — Docs (optional)
No new concepts were introduced, so you skip **Documentation Lens**.

**Outcome:**  
Working code, minimal structure, no process overhead.

---

## Quick start: Legacy project

**Scenario:** You’re modifying a large, older codebase.

### Step 1 — Shape a risky change
Request:

> “Change how user IDs are generated.”

Run **Work Item Designer**:
- It inspects existing conventions.
- Aligns with them instead of creating new structure.
- Produces a clear, bounded work item.

---

### Step 2 — Pre-flight risk
Run **Safety Lens**.

It flags:
- persistent identifier change,
- possible downstream impact.

You explicitly confirm the risk is acceptable.

---

### Step 3 — Implement
Run **Implementation Executor**:
- Scope stays tight.
- Non-goals are respected.
- Completion is recorded using existing repo conventions.

---

### Step 4 — Catch a real decision
Run **Decision Lens**.

It flags:
- future constraints introduced by the new ID format.

You decide this is worth recording.
- A small decision record is drafted and kept.

---

### Step 5 — Docs
Run **Documentation Lens**.
- It notices duplicated explanations.
- Suggests linking to a single canonical source.

You make a small, deliberate cleanup.

**Outcome:**  
The change is intentional, risk-aware, and legible to future developers.

---

## What this repo is *not*

This repo does **not**:
- automate project management,
- replace human judgement,
- enforce approvals or governance,
- standardise how every team works,
- or promise autonomous agents.

---

## Deployment surface (defined, deliberate, manual)

This repository supports four tool discovery paths by mirroring `skills/` into:

- `.claude/skills/`
- `.agents/skills/`
- `.cursor/skills/`
- `.gemini/skills/`

Deployment is intentionally manual and repo-scoped by default:
- copy from `skills/` into each tool path,
- do not use symlinks,
- do not run automatically,
- and do not delete or mutate files that were not created by this repository.

Treat deployment as a deliberate operational skill: invoke it explicitly when you want to refresh mirrors.

If you’re looking for a workflow engine or ticket system, this is probably not the right tool.

---

## Design principles

Everything here is guided by a few simple ideas:

- **Clarity beats completeness**  
- **Judgement over automation**  
- **Signals, not gates**  
- **Artifacts without bureaucracy**  
- **Human authority is non-negotiable**

If a change adds ceremony, it’s probably the wrong change.

---

## How teams usually adopt this

Most teams:
- copy the skills they want,
- change wording only when real friction appears,
- and let usage evolve through practice rather than rules.

The skills are intentionally small so they can be understood, trusted, and adapted.
