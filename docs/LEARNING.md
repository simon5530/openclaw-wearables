# Learning notes

These notes connect implementation details to reusable engineering ideas. Each
section explains what a concept solves, why it matters, and where its tradeoffs
appear in a real wearable-agent workflow.

## BYOA: Bring Your Own Agent

BYOA separates the device interface from the agent runtime:

- smart glasses capture voice and display a response;
- the companion app transports the request;
- the agent runtime handles reasoning, memory, models, and tools.

This separation lowers switching cost. A device, model provider, or tool can change
without redesigning every layer.

## OpenAI-compatible endpoint

An endpoint is a network address plus a request/response contract. The companion app
uses an OpenAI-compatible path:

```text
/v1/chat/completions
```

Compatibility reduces custom integration work, but a compatible schema does not
guarantee identical session semantics. Optional fields such as `user` can determine
whether repeated calls share a conversation.

## Loopback, reverse proxy, and private overlay network

`127.0.0.1` is loopback: only the same computer can connect directly. A phone or
wearable therefore needs a controlled network path.

Tailscale creates an encrypted private overlay network between authorized devices.
Tailscale Serve acts as a reverse proxy: it accepts tailnet-only HTTPS and forwards
traffic to the loopback gateway.

```text
wearable app → private HTTPS → reverse proxy → loopback gateway
```

This is safer than opening a router port because Internet hosts cannot directly see
the service.

## Serve vs. Funnel

- **Serve:** reachable only by authorized devices in the same tailnet.
- **Funnel:** intentionally exposes a service to the public Internet.

This implementation uses Serve. A public deployment would require a separate threat
model, rate limiting, narrow credentials, monitoring, and incident response.

## Bearer token and least privilege

A bearer token is a machine credential: possession is enough to use its authority.
If one token grants broad gateway access, it behaves more like a master key than a
single-purpose ticket.

The long-term pattern is a narrow bridge that exposes only the required operation,
for example “send one chat request to this agent,” with request-size limits, rate
limits, and structured audit events.

## Defense in depth

Private networking and application authentication solve different problems:

1. tailnet membership controls which devices can reach the endpoint;
2. bearer authentication controls which requests the application accepts.

Keeping both means one failed control does not immediately expose the agent.

## Session identity and lifecycle

An agent is not the same as a session. The agent defines durable instructions,
memory, model policy, workspace, and tools. A session stores one conversation's
short-term context.

A stable conversation identifier enables follow-up questions, but it needs a scope
and expiry. An account-wide permanent identifier risks mixing unrelated conversations.

## Multi-user isolation

Allowing a user into a channel is admission control, not full isolation. Safe routing
requires both:

- **session isolation:** each channel peer receives independent short-term context;
- **agent isolation:** guest traffic uses a separate workspace, memory index, session
  store, and minimal tool policy.

The owner is matched by an exact provider-issued identifier; a direct-message
wildcard can route other approved users to a restricted guest agent. Display names
are not security identifiers.

## Model fallback

Fallback improves availability by trying another model after a recognized provider,
quota, authentication, or transient-service failure. It should not silently route
tool-capable workloads to a model that cannot safely follow the same constraints.

Evaluate fallback candidates on context requirements, tool-use reliability, latency,
rate limits, security behavior under untrusted input, cost, and availability.

## Human confirmation for irreversible actions

A wrong answer can usually be corrected; a message sent to another person has social
and business consequences. Voice recognition also introduces errors in names,
numbers, and negation.

Use a risk-based interaction rule:

- read-only query: may execute directly;
- reversible draft: may prepare automatically;
- external or destructive action: preview target and content, then require confirmation.

## Lightweight engineering loop

1. define a concrete workflow;
2. write testable acceptance criteria;
3. document the data path and trust boundaries;
4. implement in small increments;
5. test success, unauthorized access, and restart persistence;
6. record important decisions and rejected alternatives;
7. measure outcomes before broadening scope.

## Review questions

1. Why do private networking and bearer authentication remain useful together?
2. What is the difference between an agent and a session?
3. Why should a conversation identifier have a lifecycle?
4. Which actions require human confirmation, and why?
5. Why can a fallback model improve availability but weaken security?
