# Documentation Principles

## Core Documentation Guideline

**Document to position the reader in the system, state only durable contracts, and include detail solely when its long-term value exceeds its maintenance cost.**

### What this means in practice

**Position the reader:**
- Explain where components fit in the overall system
- Provide context about boundaries and responsibilities
- Help readers navigate to related concepts

**State only durable contracts:**
- Document interfaces, APIs, and public contracts
- Focus on what is stable and long-lived
- Avoid documenting implementation details that may change

**Value vs maintenance cost:**
- Ask: "Will maintaining this documentation cost more than the value it provides?"
- Prefer executable examples and tests over prose descriptions
- Link to canonical sources rather than duplicating explanations
- Default to less documentation when uncertain

### When to document

Document when:
- Introducing a new public interface or contract
- Making architectural decisions that constrain future work
- Explaining non-obvious system boundaries or responsibilities
- Providing navigation or orientation in a complex system

Do not document when:
- The code is self-explanatory
- The detail will quickly become stale
- The information is already documented elsewhere
- The maintenance burden exceeds the long-term value

### Relationship to other skills

This principle guides the **Documentation Lens** skill when reviewing documentation for duplication, misplacement, or verbosity. Other skills may reference these principles when advisory documentation signals are needed.
