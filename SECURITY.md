# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.

**Do not open a public issue.**

Instead, please email the maintainers with:

- A description of the vulnerability
- Steps to reproduce the issue
- The potential impact

We will acknowledge your report within 48 hours and work with you to understand and address the issue.

## Supported Versions

| Version | Supported |
|---|---|
| latest | Yes |

## Security Practices

- Dependencies are audited for known vulnerabilities via `pip-audit` in CI
- Django deployment checks are run against production settings
- Pre-commit hooks detect private keys and debug statements
- Secrets are managed via environment variables, never committed to the repository
