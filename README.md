# Working with the Team Skills  
*A practical guide for developers*

This project uses a small set of **agent skills** to help humans and AI work together safely, quickly, and with minimal overhead.

These skills are **not a workflow** and **not a gatekeeping system**.  
They are best thought of as *specialist colleagues you consult at the right moment*.

You remain responsible for decisions. The skills help you notice things early and leave useful traces behind.

---

## The Five Skills (what they’re for)

### 1. **Work Item Designer**
**Use when:** you have a vague request, idea, or requirement.

**What it does:**
- Turns fuzzy input into a clear, executable work item.
- Ensures scope, acceptance checks, and non-goals are explicit.
- Helps split work if it’s too large.

**What it does *not* do:**
- It does not prioritise, estimate, or plan delivery.
- It does not implement anything.

**Rule of thumb:**  
If you can’t confidently hand the work to someone else, use this first.

---

### 2. **Safety Lens**
**Use when:** something feels risky, unclear, or irreversible.

**What it does:**
- Surfaces missing requirements or ambiguous instructions.
- Pauses before destructive or high-blast-radius actions.
- Asks the minimum questions needed to proceed safely.

**What it does *not* do:**
- It does not decide for you.
- It does not enforce approvals or policies.

**Rule of thumb:**  
If you’re about to say “I think this is probably fine”, use Safety Lens.

---

### 3. **Implementation Executor**
**Use when:** a single, well-formed work item is ready to be built.

**What it does:**
- Implements *exactly* what the work item asks for.
- Keeps scope tight and avoids “while I’m here” changes.
- Verifies acceptance checks.
- Leaves a minimal record that the work happened.

**What it does *not* do:**
- It does not expand scope.
- It does not refactor opportunistically.
- It does not decide architecture.

**Rule of thumb:**  
If the task is clear and bounded, let this do the execution.

---

### 4. **Decision Lens**
**Use when:** a change might lock in a long-term choice.

**What it does:**
- Flags when work crosses from “doing” into “deciding”.
- Surfaces trade-offs neutrally.
- Optionally helps draft a decision record.

**What it does *not* do:**
- It does not judge correctness.
- It does not require documentation.
- It does not block progress.

**Rule of thumb:**  
If future-you might ask “why did we do it this way?”, run Decision Lens.

---

### 5. **Documentation Lens**
**Use when:** writing or changing documentation, explanations, or background.

**What it does:**
- Helps avoid duplication and doc sprawl.
- Encourages single sources of truth.
- Suggests where knowledge belongs (or doesn’t).

**What it does *not* do:**
- It does not edit or rewrite docs for you.
- It does not enforce structure or templates.

**Rule of thumb:**  
If you’re writing explanation rather than code, use this before committing.

---

## A Typical Flow (how this usually looks)

This is not mandatory, just common:

1. **Define the work**
   - Use *Work Item Designer* to shape the task.

2. **Check for risk**
   - Use *Safety Lens* if anything is unclear or destructive.

3. **Build**
   - Use *Implementation Executor* to make the change.

4. **Sense-check decisions**
   - Use *Decision Lens* if APIs, schemas, or architecture are touched.

5. **Write or update docs**
   - Use *Documentation Lens* to keep docs clean and canonical.

You can skip steps when they don’t apply.  
You can repeat steps if understanding evolves.

---

## Persistence vs conversation (important)

Most skills work in **two modes**:

- **Ephemeral (default):**
  - Think, draft, explore.
  - Nothing is written unless you ask.

- **Persistent (opt-in):**
  - Backlog items, decision records, or docs are written to the repo.
  - Always explicit. Never automatic.

If you want something saved, say so.  
If you don’t, nothing will be created.

---

## How to work with legacy code

In older repos, the skills will:
- look for existing conventions,
- prefer aligning over “cleaning up”,
- propose changes instead of imposing them.

If a suggestion doesn’t fit the context, it’s fine to say:
> “Yes, but not here / not yet.”

That is a valid outcome.

---

## What good usage looks like

- You use skills to **surface issues early**, not to outsource judgement.
- You consciously accept or defer risks and decisions.
- You leave behind **small, trustworthy artefacts**, not lots of process.
- You stop when acceptance is met.

## What bad usage looks like

- Treating skills as approval gates.
- Letting them make decisions silently.
- Adding structure “because the skill suggested it”.
- Using them to justify poor thinking.

If you feel slowed down, something is being misused.

---

## One guiding principle

> **The skills exist to support professional judgement, not replace it.**

If in doubt:
- pause,
- ask,
- leave a trace,
- and move on.

That’s the whole system.