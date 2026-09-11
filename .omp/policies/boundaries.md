# Sandbox boundaries

The active native project instructions are in [`.omp/RULES.md`](../RULES.md).

This file is documentation, not an automatically loaded security policy. Docker is the technical isolation boundary. Only the repository is bind-mounted at `/workspace`. Outbound network traffic is currently permitted and is not restricted by domain.
