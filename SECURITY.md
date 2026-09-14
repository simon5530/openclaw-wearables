# Security policy

## Never commit

- API keys, gateway tokens, passwords, cookies, or OAuth tokens;
- `.env` files, private keys, certificates, databases, or runtime logs;
- channel user/group identifiers, private IPs, device names, or private chat content;
- complete agent configuration, memory files, user profiles, or secret-store exports;
- screenshots containing notifications, contacts, hostnames, or credentials.

## Safe documentation patterns

- use placeholders such as `<device>`, `<tailnet>`, and `<token>`;
- document HTTP status and behavior rather than credential values;
- publish synthetic examples instead of real conversation or calendar data;
- describe routing by role (`owner`, `guest`) rather than provider identifiers;
- keep the gateway loopback-only unless a separate public threat model is complete.

## Contribution checks

Before every release:

1. scan the current tree and complete Git history for secrets;
2. scan for personal email, home-directory paths, channel IDs, private IPs, and hostnames;
3. review binary metadata and screenshots;
4. verify links and shell syntax;
5. confirm dependency and asset licenses;
6. run positive, unauthorized, and restart-persistence tests where applicable.

If a credential reaches Git history, deleting the latest file is insufficient. Revoke
or rotate the credential, rewrite the affected history, scan again, and document the
incident without publishing the secret.

## Vulnerability reporting

Do not open a public issue containing a credential or exploitable private deployment
detail. Use GitHub's private vulnerability reporting feature when enabled.
