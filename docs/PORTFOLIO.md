# Portfolio case study

## Business problem

Smart glasses can shorten the path from observation or intent to digital assistance,
but useful adoption requires more than a model demo. The system must integrate device,
mobile, network, agent, identity, and approval layers without exposing a privileged
runtime or creating unreviewable external actions.

## Stakeholders and constraints

- **Wearer:** low-friction voice interaction and readable responses.
- **Operations/security:** private connectivity, credential hygiene, least privilege,
  and reproducible recovery.
- **Product/platform:** multiple hardware vendors and evolving device APIs.
- **Business owner:** measurable time saved without unacceptable privacy or reliability risk.

## Solution strategy

1. validate a supported, private, read-only conversation path on physical hardware;
2. add conversation lifecycle management;
3. introduce a narrow bridge for observability, policy, and rate limiting;
4. add approval-gated external workflows;
5. test portability on another wearable platform.

## Evidence

- physical Even G2 voice-to-display flow completed in Chinese;
- unauthenticated endpoint access rejected;
- gateway remained loopback-only behind tailnet-only HTTPS;
- service checks repeated after restart;
- fresh owner and guest channel messages reached separate agents and sessions;
- secrets and personal identifiers excluded from the public project and Git history.

## Evidence gaps

- median and p95 end-to-end latency;
- repeated-run success rate and failure taxonomy;
- long-running stability and token rotation drill;
- second-device portability;
- user study comparing wearable interaction with phone-first interaction.

## Transferable skills demonstrated

- translating an ambiguous idea into bounded releases and acceptance criteria;
- integrating hardware, mobile, networking, APIs, and agent runtimes;
- threat modeling credentials, trust boundaries, and multi-user routing;
- distinguishing configuration checks from real end-to-end evidence;
- documenting architectural tradeoffs and explicitly preserving evidence gaps;
- connecting a technical prototype to operational and commercial adoption criteria.

## Candidate business metrics

- task completion time relative to phone-first workflow;
- percentage of interactions completed without opening the phone;
- p50/p95 voice-to-display latency;
- unauthorized-request rejection rate;
- confirmation cancellation rate for outbound actions;
- cross-device integration effort using the same bridge contract.
