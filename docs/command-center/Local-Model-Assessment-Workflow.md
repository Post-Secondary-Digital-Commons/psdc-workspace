# Local Model Assessment Workflow

**Status:** Draft workflow, exercised once on 2026-10-07  
**Implementation state:** Local inference observed; automated review orchestration not implemented  
**Authority:** Review aid only; model output cannot change a decision, contract, or readiness state

## Recommendation

Use the installed models as a two-stage local review pair:

| Role | Model | Why | Boundary |
|---|---|---|---|
| Fast bounded reviewer | `qwen3:8b` | Responsive enough for focused source chunks | Never infer beyond supplied files |
| Focused adjudicator | `qwen3:14b` | Stronger reasoning on a compact disputed finding set | Do not feed the whole ecosystem at once |
| Primary engineering review | Codex | Repository inspection, deterministic checks, remediation | Must disposition model findings against sources |
| Independent cross-review | Claude | Different-model challenge of the final findings | Currently blocked in Claude Code by organization policy |

`qwen3:14b` is the strongest installed local model by parameter count, but it is
not the best whole-project reviewer on this laptop. The observed Ollama session
used a 4,096-token context and split the model across CPU and the RTX 4050 laptop
GPU. A large all-in-one review lost instruction fidelity and was stopped. The
8B model completed bounded reviews materially faster, so the practical design
is **small chunks first, compact adjudication second**.

## Review pipeline

```text
authoritative source manifest
          |
          v
deterministic parsing and validation
          |
          v
bounded source packets (one question each)
          |
          +--> qwen3:8b findings
          |
          v
deduplicate + attach exact source citations
          |
          +--> qwen3:14b adjudicates disputed/high-risk items
          |
          v
Codex verifies against repositories and executes safe fixes
          |
          v
Claude independently challenges the disposition
          |
          v
human owner accepts decisions; evidence registry records proof
```

## Required packet contract

Every model packet must declare:

1. objective and excluded questions;
2. exact file paths, commit IDs, and content hashes;
3. authority precedence;
4. evidence-state vocabulary;
5. accepted decisions that may be checked for contradiction but not relitigated;
6. maximum requested findings;
7. required source heading or line evidence;
8. a `cannot verify` option;
9. output schema; and
10. explicit instruction not to treat absence from the packet as absence from the repository.

The final rule prevents the failure observed in this assessment: the local
model sometimes declared a contract or skill missing when it was outside that
particular bounded packet.

## Disposition states

| State | Meaning |
|---|---|
| Confirmed | Source evidence supports the finding |
| Partly confirmed | Risk is real, but the stated cause or remedy is incomplete |
| Duplicate | Existing rule or backlog item already covers it |
| Packet limitation | The reviewer lacked the artifact needed to decide |
| Rejected | The finding contradicts supplied or repository evidence |
| Remediated | A reviewed change and verification evidence now address it |

No finding becomes a project fact merely because multiple models repeat it.
Agreement raises review priority; repository evidence determines disposition.

## Performance and capacity rules

- Keep an 8B packet below roughly half the active context so the response and
  governing instructions have room.
- Put one bounded context or one contract family in each packet.
- Send the 14B model a compact finding table, not all source documents again.
- Require structured output and reject uncited claims.
- Cache immutable source packets by digest.
- Record model name, quantization, context, prompt digest, duration, and exit
  state for every assessment.
- Never expose secrets, private student records, or unrestricted workspace logs
  to a review model.

## Acceptance criteria for automation

Automation is not complete until it can:

- build digest-pinned packets reproducibly;
- validate responses against `assessment.result.v1`;
- reject citations to absent sources;
- distinguish model failure, timeout, truncation, and successful completion;
- retain raw output separately from reviewer disposition;
- compare two model passes without counting agreement as truth;
- emit evidence without promoting implementation or deployment readiness; and
- rerun the same packet against a newer model while preserving the old result.

## Current evidence and limitations

The October 7 run demonstrates that both installed Qwen models can review
bounded Markdown inputs. It does not establish semantic accuracy, production
capacity, unattended reliability, or an acceptable student-data boundary.
Claude Code did not perform its pass because the signed-in organization has
disabled Claude subscription access for Claude Code. That blocker is recorded
with the review artifacts; it must not be represented as a completed review.
