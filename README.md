# OMP Harness

Een begrijpelijke, uitbreidbare werkomgeving voor [Oh My Pi (OMP)](https://github.com/can1357/oh-my-pi) in een VS Code Dev Container. De agent draait als gewone gebruiker in Docker; je project blijft op je computer.

De harness combineert containerinstellingen, goedkeuringsprofielen en instructies voor compacte, menselijk onderhoudbare code. Het is geen eigen AI-model en geen garantie tegen schadelijke acties.

## Snel starten

Je hebt Git, Docker Desktop, VS Code en de extensie **Dev Containers** nodig.

1. Clone deze repository en open de map in VS Code.
2. Kies **Dev Containers: Reopen in Container** via het commandopalet.
3. Voer in de containerterminal `make doctor` uit.
4. Start `make login`; typ in OMP `/login openai-codex` en volg de browseraanmelding.
5. Gebruik daarna `make safe`.

Deze route gebruikt ChatGPT-aanmelding, geen OpenAI API-key. Beschikbaarheid hangt af van je account, organisatiebeleid en ondersteuning door OMP. OMP is een extern project: een Business-abonnement is geen algemene toestemming om bedrijfsdata met externe tools te delen.

Lees de [beginnershandleiding](docs/getting-started.md) voor alle stappen en een eerste oefening.

## Dagelijks gebruik

| Commando in de container | Betekenis |
| --- | --- |
| `make help` | Overzicht van opdrachten. |
| `make login` / `make logout` | OMP openen met aanwijzingen voor aan- of afmelden. |
| `make safe` | Goedkeuring voor edits en uitvoering; start hiermee. |
| `make normal` | Edits toestaan; prompts voor onder andere shelluitvoering. |
| `make yolo` | Minder goedkeuringen; alleen voor bewust begrensd werk. |
| `make doctor` | Draaiende container en OMP-profielen controleren. |
| `make validate` | Statische controles zonder modelaccount. |
| `make version` / `make profiles` | Versie en profielmodi bekijken. |

Argumenten doorgeven kan met `make safe ARGS="--help"`. Gebruik alleen vertrouwde argumenten: Make gebruikt een shell.

## Bestanden

| Map | Gebruik |
| --- | --- |
| `incoming/` | Kopieën van bronmateriaal; niet wijzigen is een afspraak, geen read-only mount. |
| `projects/` | Werkprojecten. |
| `output/` | Rapporten en andere resultaten. |
| `temp/` | Tijdelijke bestanden. |

Inhoud van deze mappen wordt standaard niet opgenomen in Git. Maak zelf back-ups of gebruik voor een werkproject een eigen repository.

## Documentatie

- [Starten en dagelijks werken](docs/getting-started.md)
- [Opzet, keuzes en wat is toegevoegd](docs/architecture.md)
- [Veiligheid en beperkingen](docs/security.md)
- [Uitbreiden: tools, skills, projecten en MCP](docs/extending.md)
- [Problemen oplossen](docs/troubleshooting.md)
- [Bijdragen en controles](CONTRIBUTING.md)

De standaardbuild volgt de nieuwste OMP-release. Zie de architectuurdocumentatie voor versiebeheer. OAuth-gegevens blijven in een eigen Docker-volume per devcontainer. Dat volume is gevoelig en wordt niet automatisch door deze repository versleuteld.

De bestaande [licentie](LICENSE) is behouden.
