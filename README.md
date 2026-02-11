# Lightweight AI Development Agent Skills

<table style="background-color: #F4EAD0;color: #29004B;">
  <tr>
    <td width="132" style="border:none; background-color: #F4EAD0;" valign="middle">
      <a href="https://we3.io"><img src="assets/WE3io-logo-200px.png" alt="WE3io Logo" width="56" /></a>
    </td>
    <td style="border:none; background-color: #ffF4EAD0f;">
      <strong>WE3</strong> builds products and companies with senior Product, Design, and Engineering teams. This repository is part of our open-source community offerings. <a href="https://we3.io/brief">Start your brief</a>.
    </td>
  </tr>
</table>

---

This repository contains a small, reusable set of **AI agent skills** designed to support disciplined, low-ceremony software development.

These skills are **not a framework**, **not a workflow**, and **not a ticketing system**.  
They are portable, team-level behaviours that help humans and AI assistants work together safely and effectively in real codebases.

They’ve been designed and exercised across:
- solo developers and distributed teams,
- greenfield projects and legacy systems,
- exploratory work and production changes.

---

## Quick navigation

- [Lightweight AI Development Agent Skills](#lightweight-ai-development-agent-skills)
  - [Quick navigation](#quick-navigation)
  - [Canonical skill source](#canonical-skill-source)
  - [Why this exists](#why-this-exists)
  - [The five skills](#the-five-skills)
    - [1. Work Item Designer](#1-work-item-designer)
    - [2. Implementation Executor](#2-implementation-executor)
    - [3. Decision Lens](#3-decision-lens)
    - [4. Documentation Lens](#4-documentation-lens)
    - [5. Safety Lens](#5-safety-lens)
  - [How the skills are meant to be used](#how-the-skills-are-meant-to-be-used)
  - [Invocation examples](#invocation-examples)
  - [Persistence vs conversation (important)](#persistence-vs-conversation-important)
  - [Quick starts](#quick-starts)
    - [Greenfield project](#greenfield-project)
    - [Legacy project](#legacy-project)
  - [What this repo is *not*](#what-this-repo-is-not)
  - [Installation and deployment](#installation-and-deployment)
  - [Design principles](#design-principles)
  - [How teams usually adopt this](#how-teams-usually-adopt-this)
  - [Related](#related)

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

See `skills/documentation-lens/documentation-principles.md` for full documentation guidance.

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

## Invocation examples

Use plain requests in your assistant:

- `Use work-item-designer to shape this into one executable task.`
- `Run safety-lens on this plan and flag any risky assumptions.`
- `Use implementation-executor to implement this item exactly as written.`
- `Run decision-lens on this diff and flag potential architectural decisions.`
- `Use documentation-lens to check for duplication or misplaced docs.`

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

## Quick starts

### Greenfield project

**Scenario:** You’ve just created an empty repo for a new internal service.

1. Shape the work with **Work Item Designer** from a vague request like:  
   > "We need a simple todo app to validate the flow."
2. Run **Safety Lens** for a quick pre-flight risk check.
3. Implement with **Implementation Executor** using the accepted work item only.
4. Run **Decision Lens** on the diff if architecture might have changed.
5. Use **Documentation Lens** only if new durable knowledge was introduced.

**Outcome:**  
Working code, minimal structure, no process overhead.

---

### Legacy project

**Scenario:** You’re modifying a large, older codebase.

1. Shape a risky request with **Work Item Designer**, for example:  
   > "Change how user IDs are generated."
2. Run **Safety Lens** and explicitly confirm risk when identifier changes are involved.
3. Execute with **Implementation Executor** and keep scope tight.
4. Run **Decision Lens** and record only meaningful, long-term decisions.
5. Run **Documentation Lens** to consolidate duplicated explanation into canonical docs.

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

## Installation and deployment

`skills/` is the only source of truth. Installation mirrors that directory into tool discovery paths.

Use the installer script:

```bash
scripts/install-skills.sh --target /path/to/target-repo
```

For full target paths, options (`--scope`, `--dry-run`, `--skip-existing`, `--overwrite`), and safety behavior, see [INSTALLATION.md](INSTALLATION.md).

Installation is opt-in: run when you want to refresh mirrors, not automatically on clone, CI, or deploy.

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

---

## Related

**[AI Assistant Rules](https://github.com/WE3io/ai-assistant-rules/)** — Unified rules and best practices for AI coding assistants (Cursor, Claude Code, Codex, Gemini CLI, Antigravity), derived from AI Blindspots. Use it alongside these skills for comprehensive guidance across tools.

See also [CONTRIBUTING.md](CONTRIBUTING.md) for contribution scope and review expectations.
