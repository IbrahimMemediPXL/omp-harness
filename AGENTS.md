# Contributing to OMP Harness

Keep task.maxConcurrency at 3 in the baseline and all profiles. Use at most three concurrent subagents; queue extra work. Do not bypass the limit with nested delegation or additional OMP sessions.

Preserve Docker isolation, non-root execution, one host repository bindmount, and ChatGPT OAuth as the default login. No host-home or Docker-socket mounts. Rules and skills are behavioral guidance, not security enforcement.

Inspect current files and Git status. Keep changes focused, use a feature branch and PR, preserve user changes, and never force-push. Read docs/architecture.md and docs/security.md before modifying runtime controls. Consult current upstream OMP schemas before changing settings or commands.

Run make validate and git diff --check. Build the image and run make doctor inside it when Docker is available. Report skipped checks accurately; static validation does not prove runtime behavior. Never request or print OAuth tokens. Keep private work under ignored working directories and review staged paths before publishing this public repository.
