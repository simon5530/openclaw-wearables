# Architecture decision records

## ADR-001: Start with the vendor-supported BYOA path

- **Status:** accepted and validated
- **Decision:** Connect the companion app directly to OpenClaw's compatible chat endpoint.
- **Reason:** This is the shortest supported path and isolates hardware/API feasibility
  before adding messaging or workflow automation.
- **Tradeoff:** The client holds a broad gateway credential until a narrow bridge exists.

## ADR-002: Keep the gateway loopback-only

- **Status:** accepted and validated
- **Decision:** Publish private HTTPS through Tailscale Serve; do not use public port
  forwarding or Tailscale Funnel.
- **Reason:** Reduces the reachable attack surface while preserving mobile access.
- **Tradeoff:** Every client must join the tailnet, and Serve lifecycle is managed
  separately from the agent runtime.

## ADR-003: Preserve application authentication behind the private network

- **Status:** accepted and validated
- **Decision:** Continue requiring bearer authentication after tailnet admission.
- **Reason:** Network identity and application authority are independent controls.
- **Evidence:** Unauthenticated endpoint request returned HTTP 401.

## ADR-004: Separate conversation from outbound communication

- **Status:** planned
- **Decision:** Voice may prepare a message, but sending requires a wearable preview of
  recipient and content followed by explicit confirmation.
- **Reason:** Speech recognition errors can create irreversible social or business impact.

## ADR-005: Require production-quality fallback models

- **Status:** accepted
- **Decision:** Do not place a small model in the automatic fallback chain for an
  unsandboxed, tool-capable agent solely because it is inexpensive or local.
- **Reason:** Fallback must preserve acceptable context handling, instruction following,
  and tool safety—not merely return text.

## ADR-006: Accept one-shot sessions in the first hardware release

- **Status:** accepted; improvement planned
- **Decision:** Validate single-turn voice interaction before adding a conversation bridge.
- **Reason:** The client does not currently provide a stable conversation identifier.
- **Tradeoff:** Follow-up questions may not inherit short-term context.

## ADR-007: Isolate channel users at both agent and session layers

- **Status:** accepted and validated
- **Decision:** Route the owner to the private agent by exact provider identity; route
  other direct-message users to a restricted guest agent, with per-peer sessions.
- **Reason:** Pairing or allowlisting controls admission but does not isolate memory,
  workspaces, session stores, or tools.
- **Limitation:** Workspace/tool separation is a logical security boundary. High-risk
  guest tools would require stronger sandboxing or a separate runtime boundary.

## ADR-008: Maintain evidence as Git-backed documentation

- **Status:** accepted
- **Decision:** Keep current status in README, reusable concepts in LEARNING, and
  consequential tradeoffs in ADRs.
- **Reason:** Reviewable version history turns a setup exercise into reproducible
  engineering and portfolio evidence.

## ADR-009: Scale one active gateway before adding gateways

- **Status:** accepted as the evolution direction
- **Decision:** Add devices, sessions, agents, and remote nodes behind one active
  gateway. Introduce another gateway only for hard isolation or active-passive
  recovery, not as the default way to add capacity.
- **Reason:** Channel webhooks need one authoritative receiver, and shared mutable
  session state makes uncoordinated active-active gateways prone to duplicate or
  divergent processing.
- **Tradeoff:** The gateway remains a failure domain until health checks, verified
  backups, a stable ingress name, and a tested standby cutover are implemented.
