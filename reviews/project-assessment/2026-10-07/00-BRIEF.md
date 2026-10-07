# PSDC Bounded Project Assessment Brief

## Objective

Assess the current PSDC documentation-and-contract project, with special focus
on the new governed agent-skill pack, workspace command center, repository
catalog, evidence model, and dual-lane AI architecture.

## Snapshot and scope

- Workspace command-center branch: `codex/workspace-command-center-20261007`
- Agent-skill commit: `984e54b`
- Architecture commit under review: `d4cd881d`
- Runtime implementation: absent unless an artifact in this bundle proves otherwise
- Deployment/production evidence: absent unless an evidence record proves otherwise

This is a bounded assessment of the supplied files, not proof that every file in
the ecosystem has been reviewed.

## Apply these Matt Pocock-derived methods

1. **Domain modeling:** flag overloaded or conflicting terms and bounded-context
   leaks. Do not turn the glossary into an implementation spec.
2. **Grill with docs:** identify questions that materially change architecture,
   but distinguish owner decisions from reviewer recommendations.
3. **Research discipline:** treat primary sources and repository artifacts as
   stronger than summaries; identify unverifiable claims.
4. **To-spec:** check problem, solution, user stories/actors, implementation
   decisions, testing decisions, and explicit exclusions.
5. **Wayfinder:** separate sharp, actionable questions from unresolved fog.
6. **Writing for agents:** check pointers, completion criteria, progressive
   disclosure, duplication, and instructions that cannot be tested.

## PSDC authority and evidence rules

- Decision Register > accepted ADRs > contracts > subsystem documents >
  institution overlays > generated/Obsidian views.
- `proposed != documented != contracted != structurally_validated != implemented
  != deployed != production_proven`.
- Separate observed facts, documented claims, inferences, assumptions, and
  recommendations.
- Accepted founder decisions are checked for contradiction, not re-litigated.
- An institution remains sovereign; a common document cannot silently bind a
  local deployment choice outside common contracts.

## Required output

1. Executive assessment in five sentences or fewer.
2. Twelve rubric rows, each scored 0-4, with evidence and the next evidence
   needed for a higher score.
3. Ten worst findings, ordered by severity. Each needs: severity, basis, source,
   failure scenario, and smallest coherent remediation.
4. What was checked and found sound.
5. Claims that could not be verified.
6. The next three tracer-bullet vertical slices and their blocking edges.
7. A final warning against any readiness inflation in your own answer.

Do not invent file contents, runtime tests, approvals, or deployment facts.
