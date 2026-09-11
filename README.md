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

MCP-servers zijn **optioneel**. GitHub staat klaar in `.omp/mcp.json`, maar is standaard uitgeschakeld met `enabled: false`; zolang je het niet activeert is geen GitHub-token nodig. Kies zelf of je MCP gebruikt, welke servers je vertrouwt en welke rechten je toestaat. Zie [MCP kiezen en instellen](docs/extending.md#mcp) voor activering en persoonlijke configuratie.

## Dagelijks gebruik

Alle profielen begrenzen OMP tot **drie gelijktijdige subagents per sessie**, naast de hoofdagent. Extra taken wachten. Zie de [uitbreidingsgids](docs/extending.md) voor de grenzen van deze instelling.

| Commando in de container | Betekenis |
| --- | --- |
| `make help` | Overzicht van opdrachten. |
| `make login` / `make logout` | OMP openen met aanwijzingen voor aan- of afmelden. |
| `make safe` | Goedkeuring voor edits en uitvoering; start hiermee. |
| `make normal` | Schrijven via `write` toestaan; prompts voor `edit`/patch en shelluitvoering. |
| `make yolo` | Minder goedkeuringen; alleen voor bewust begrensd werk. |
| `make doctor` | Draaiende container en OMP-profielen controleren. |
| `make validate` | Statische controles zonder modelaccount. |
| `make version` / `make profiles` | Versie en profielmodi bekijken. |

Argumenten doorgeven kan met `make safe ARGS="--help"`. Gebruik alleen vertrouwde argumenten: Make gebruikt een shell.

## OMP-commando's

De `make`-commando's hierboven horen bij deze harness. Hieronder staan veelgebruikte commando's van **OMP zelf**, gecontroleerd voor OMP 18.1.17. Het is een selectie; opties kunnen per versie veranderen.

### In de containerterminal

Voer deze commando's uit vanuit `/workspace`, niet in het invoerveld van OMP.

| Commando | Uitleg |
| --- | --- |
| `omp` | Start OMP rechtstreeks met de geladen configuratie. Gebruik voor dagelijks werk bij voorkeur `make safe`. |
| `omp --help` | Toon beschikbare terminalcommando's, opties en voorbeelden. |
| `omp --version` | Toon de geïnstalleerde OMP-versie. |
| `omp --continue` | Hervat de laatste sessie voor de huidige werkmap. |
| `omp --resume` | Open de sessiekiezer om een eerdere sessie te hervatten. |
| `omp models` | Toon de modelcatalogus; een vermelding bewijst niet dat je account toegang heeft. |
| `omp models find <zoekterm>` | Zoek een model op naam of deel van de naam. |
| `omp config get task.maxConcurrency` | Lees de ingestelde limiet voor gelijktijdige subagenten. |
| `omp -p "Leg de projectstructuur uit"` | Voer een opdracht niet-interactief uit en sluit daarna af. Dit gebruikt een model en kan tools aanroepen. |

Vervang `<zoekterm>` door je eigen tekst, zonder de punthaken. Om expliciet het SAFE-profiel te behouden bij hervatten: `make safe ARGS="--continue"` of `make safe ARGS="--resume"`. Voor de effectieve instellingen van de drie harness-profielen gebruik je `make profiles`; de losse `config get`-opdracht hierboven selecteert geen profieloverlay.

### Binnen een actieve OMP-sessie

Typ deze slashcommando's **in het invoerveld van OMP**, niet in Bash.

| Commando | Uitleg |
| --- | --- |
| `/login openai-codex` | Start de browseraanmelding voor de ChatGPT/Codex-provider. |
| `/logout` | Kies de provider waarbij je wilt afmelden; dit verwijdert niet je werkbestanden. |
| `/model` | Bekijk en kies een model voor je werk. De beschikbare modellen hangen af van je providers en account. |
| `/session info` | Toon informatie en statistieken over de huidige sessie. |
| `/context` | Bekijk hoeveel context de huidige sessie gebruikt. |
| `/compact` | Vat eerdere context samen om ruimte vrij te maken; dit kan modelgebruik kosten. |
| `/tools` | Bekijk welke tools beschikbaar zijn in deze sessie. |
| `/review` | Start een codereview; dit kan reviewer-subagenten en extra modelgebruik inzetten. |
| `/jobs` | Bekijk achtergrondtaken en hun status. |
| `/mcp list` | Toon geconfigureerde MCP-servers, hun status en configuratiebron. |
| `/mcp enable github` | Activeer de optionele GitHub-server. Stel eerst de gewenste authenticatie en rechten in. |
| `/mcp disable github` | Schakel GitHub MCP uit; dit trekt je token niet in bij GitHub. |
| `/mcp test github` | Test de verbinding met GitHub MCP; dit bewijst geen schrijfrechten. |
| `/mcp reload` | Herlaad MCP-configuratie en runtime-tools na wijzigingen. Dit importeert geen variabelen uit een andere terminal. |

Bij MCP-commando's kun je `github` vervangen door de naam van een andere zelfgekozen server. GitHub blijft standaard uitgeschakeld; zie [MCP instellen](docs/extending.md#mcp) voor de opt-in en configuratiebronnen. Gebruik `omp <commando> --help` voor terminaldetails en de [upstream OMP-documentatie](https://github.com/can1357/oh-my-pi#readme) voor meer mogelijkheden.

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
