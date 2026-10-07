**Three highest-risk ambiguities/contradictions:**

1. **"Prohibited dependency cycles" vs. "Federation dependency requirements":**  
   *Heading:* Cyclic Dependency Enforcement  
   *Failure Scenario:* A peer dependency may implicitly require another peer, violating the "no cyclic dependency" rule, yet the federation dependency requirements expect trust declarations.  
   *Fix:* Explicitly ban any peer from requiring another in contracts; enforce trust via ADRs, not dependencies.

2. **"Client cannot call model runtimes..." vs. "Local academic provider":**  
   *Heading:* Adapter vs. Direct Access  
   *Failure Scenario:* A development client may call a local academic provider directly, violating the rule against direct access to LMS databases.  
   *Fix:* Enforce that all external calls must use an adapter, even in development environments.

3. **"Federation peer cannot become a local identity..." vs. "Fediverse identity":**  
   *Heading:* Identity Isolation  
   *Failure Scenario:* Fediverse identity may be treated as institutional identity, violating federation isolation.  
   *Fix:* Explicitly enforce that Fediverse identity must remain a federated peer, not a local authority.

**Three sound invariants:**

- **"Producer owns availability":** A producer must ensure its contract is always available and compatible.
- **"Consumer owns timeouts and retries":** Consumers must handle retries, timeouts, and fallbacks without affecting the producer.
- **"Trust is denied by default":** Peer trust must be explicitly declared, not assumed or transitive.

**Unverifiable claims:**

- *"A federation peer cannot become a local identity..."* – This is a policy claim, not a verifiable contract clause.

