---
name: principle-redesign-from-first-principles
description: Apply when integrating a new requirement into an existing design.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/principle-redesign-from-first-principles
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:principle-redesign-from-first-principles`.


# Redesign From First Principles

When integrating a change, don't bolt it onto the existing design. Redesign as if the requirement had been a foundational assumption from the start.

- Read all affected files and understand the current design
- Ask: "if we were writing this from scratch with this new requirement, what would we build?"
- Propagate the change through every reference: types, docs, examples, rationale sections
- Think about the whole redesign, then deliver it incrementally

This is the method for preserving option value when integrating changes into an existing design.
