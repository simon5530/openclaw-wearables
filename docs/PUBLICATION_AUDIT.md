# Publication audit

Date: 2026-09-14

## Scope

- current repository tree;
- all commits and reachable Git objects;
- commit author/committer metadata;
- GitHub visibility and repository metadata;
- documentation links and shell syntax.

## Checks

- Gitleaks 8.30.1 full-history scan: no secrets detected.
- Custom privacy scan: no personal email, channel sender ID, user home path,
  Tailscale hostname/IP, auth-profile ID, or private-key marker detected.
- Commit history rebuilt as a sanitized public baseline using a GitHub noreply address.
- No screenshots, archives, databases, logs, `.env` files, or private configuration included.
- Third-party source/assets: none bundled; product names appear only as interoperability references.
- License: MIT.
- Local Markdown links resolved and `scripts/preflight.sh` passed shell syntax validation.

## Residual limitations

- Pattern scanning cannot prove the absence of every possible sensitive semantic detail.
- Hardware validation is environment-specific. Public evidence is intentionally
  de-identified and does not include private endpoints or raw logs.
