**Three Highest-Risk Ambiguities/Contradictions:**

1. **"Institution-First Federation Locality" (ADR-0013) vs. "No federation peer becomes a local identity..." (Dependency Rule):**  
   *Failure Scenario:* Federated peers may assume local identity or policy authority, violating institutional sovereignty.  
   *Fix:* Clarify that federation peers are strictly gateways, not identity or policy authorities.

2. **"No cross-repository private imports" (Dependency Rule) vs. "Institution-signed client deployment manifests" (Shared Contracts):**  
   *Failure Scenario:* Client manifests may bypass shared contracts, enabling insecure or unapproved data flows.  
   *Fix:* Enforce manifest validation at edge gateways before any cross-repository access.

3. **"No client-to-model-provider bypass" (Dependency Rule) vs. "AI model aliases, inference requests" (Shared Contracts):**  
   *Failure Scenario:* Clients may directly access model providers, bypassing policy and observability.  
   *Fix:* Require all model requests to flow through Commons AI Fabric with policy enforcement.

**Three Sound Invariants:**

- **Institutional Sovereignty:** Institutions control identity, policy, and data residency; no external system may override these.
- **Control Plane Isolation:** All federated systems must operate as gateways, not as identity or policy authorities.
- **Observability Mandate:** All flows must be traceable, logged, and subject to audit, including federated and compute workloads.

**Unverifiable Claims:**

- *"Platform creates distinctive value in orchestration..."* (Settled Constraints): No evidence provided of measurable value beyond architectural claims.  
- *"Mature standards adopted before new primitives"* (Settled Constraints): No reference to specific standards or adoption timelines.  
- *"Institution-Branded Client Access" (Shared Contracts):* No evidence of branding enforcement or metadata validation in deployment pipelines.

