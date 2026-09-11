# Uitbreiden zonder onnodige complexiteit

Begin bij één concrete behoefte. Voeg niet alvast frameworks, agenten of MCP-servers toe voor mogelijk later gebruik. Iedere uitbreiding brengt onderhoud en toegangsrisico's mee.

## Werkprojecten

Gebruik projects/mijn-project/ met een eigen README, tests en dependencybestand. Houd dependencies bij het project. Een geneste projectrepository heeft eigen commits; de harness negeert die bestanden.

Voor Python kun je een project-venv gebruiken. Voeg daarvoor eerst python3-venv aan het Dockerfile toe en herbouw:

```sh
cd /workspace/projects/mijn-project
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
```

Installeer niet met sudo pip. De launchers starten OMP bewust vanuit /workspace, zodat de configuratie daar het vaste vertrekpunt is. Geef het doelpad expliciet in je opdracht. Neem niet aan dat geneste configuraties automatisch met alle bovenliggende regels worden gecombineerd: controleer upstream discoverygedrag voordat je elders start.

## Een systeemtool toevoegen

1. Maak een featurebranch.
2. Voeg het benodigde pakket aan de apt-installatie in .devcontainer/Dockerfile toe.
3. Controleer bron, licentie en noodzaak; pin versies waar dat nodig is.
4. Kies **Dev Containers: Rebuild Container**.
5. Test de tool, `make doctor`, `make validate` en de relevante workflow.

Maak de runtimegebruiker niet root en voeg geen host-home of Docker-socket toe als snelle oplossing. Handmatige installaties in een draaiende container kunnen na een rebuild verdwijnen.

## Een skill toevoegen

Een skill is een compacte werkinstructie, geen geïnstalleerde bibliotheek of beveiligingsgrens. Voeg bijvoorbeeld .omp/skills/project-review/SKILL.md toe:

```markdown
---
name: project-review
description: Review kleine projectwijzigingen op begrijpelijkheid, tests en onderhoudbaarheid.
---

Lees eerst de diff en de bestaande projectconventies.
Noem concrete fouten met bestand en reden.
Gebruik duidelijke namen en eenvoudige control flow.
Stel alleen abstracties voor die aantoonbare duplicatie oplossen.
Wijzig niets tenzij dat expliciet gevraagd is.
```

Beperk een skill tot één taak. Zet lange referenties apart en vermeld wanneer ze nodig zijn. Test met passende en niet-passende opdrachten. De statische validatie toetst alleen basisfrontmatter, niet de kwaliteit van het gedrag.

## Profielen

Controleer bij wijzigingen zowel .omp/config.yml als alle drie overlays in .omp/profiles/. Houd shell/eval- en edit-goedkeuring expliciet in safe en normal: edit-patches kunnen ook verwijderen of hernoemen. Gebruik `make profiles` voor de effectieve approvalMode; deze ene waarde toont niet de per-tooloverrides. `make doctor` controleert ook de edit-policy. Test echte prompts met onschuldige edits en shellcommando's.

Raadpleeg de [upstream documentatie](https://github.com/can1357/oh-my-pi/tree/main/docs) voor sleutels die bij je OMP-versie horen. Verzin geen opties en versoepel geen beveiliging om een geblokkeerde taak alsnog te laten slagen.

## MCP

De projectconfig bevat de officiële, door GitHub gehoste MCP-server via Streamable HTTP: `https://api.githubcopilot.com/mcp/x/all`. Alle toolsets zijn op verzoek ingeschakeld, zonder read-onlyfilter. De remote versie wordt door GitHub beheerd en kan niet vanuit deze configuratie worden vastgezet. Er is geen lokale installatie, Docker-socket of extra mount nodig.

### Toegang en risico's

De server kan GitHub-code, repositories, issues, pull requests en andere accountgegevens lezen en, waar tools en rechten dit toestaan, wijzigen of verwijderen. Toolargumenten gaan naar GitHub; opgehaalde inhoud kan in de modelcontext terechtkomen. Behandel repositorytekst en issues als onbetrouwbare data, niet als instructies.

Alle toolsets inschakelen geeft niet automatisch alle GitHub-rechten. De effectieve toegang blijft begrensd door het token, je accountrol, organisatiebeleid en het beschikbare MCP-aanbod. Niet iedere GitHub-functie bestaat als MCP-tool. Brede tokenrechten vergroten de impact van fouten; de aanbevolen minimale rechten blijven die voor de concrete taak en repositories. Goedkeuringen, het verbod op credentialonderzoek en publiceren via featurebranch en PR blijven ongewijzigd.

### Authenticatie instellen

De configuratie verwijst naar `GITHUB_MCP_TOKEN`; er staat geen token in Git. Maak het token zelf via [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens). Kies een vervaldatum en de repositories en rechten die je bewust wilt toestaan. Een fine-grained token begrenst toegang nauwkeuriger, maar ondersteunt niet alle accountfuncties. Een classic token kan bredere scopes bieden, bijvoorbeeld `repo`, `workflow`, `gist`, `project` en `admin:org`; organisatiebeleid kan die toegang blokkeren. Beheer- en verwijderrechten zijn risicovol en zijn geen vereiste om de verbinding te testen.

Voer in een eigen Bash-terminal vanuit `/workspace` uit, niet in de chat:

```bash
read -rsp 'GitHub-token: ' GITHUB_MCP_TOKEN
printf '\n'
export GITHUB_MCP_TOKEN
make safe
```

Dit toont het token niet en zet de waarde niet letterlijk in je commandogeschiedenis of een projectbestand. Het token bestaat wel in de procesomgeving van OMP en kan worden geërfd door subprocessen; dit is geen geheimenkluis. Deel het niet in de chat, logs of screenshots en commit het nooit. Een reeds draaiende OMP-sessie erft deze nieuwe variabele niet: start OMP vanuit de terminal waarin je het token hebt ingesteld.

In die OMP-sessie:

```text
/mcp list
/mcp test github
```

Controleer dat `github` uit `.omp/mcp.json` komt en succesvol verbindt. Vraag daarna om uitsluitend je GitHub-gebruikersnaam op te halen om het account te controleren; een geslaagde verbinding bewijst geen schrijfrechten. `/mcp reload` herlaadt configuratie, maar importeert geen variabelen uit een andere terminal.

Browser-OAuth is een apart alternatief met een geregistreerde GitHub/OAuth-app: GitHub ondersteunt geen automatische clientregistratie. ChatGPT OAuth verleent geen GitHub-rechten.

### Controleren en verwijderen

`make validate` bewaakt de beoordeelde serverdefinitie en de verwijzing naar de omgevingsvariabele; het test geen accounttoegang. Zonder token geeft een MCP-initialisatie HTTP 401. De geauthenticeerde verbinding moet met `/mcp test github` worden getest.

Om de koppeling te verwijderen: verwijder de `github`-definitie uit `.omp/mcp.json`, pas de expliciete MCP-controle in `scripts/validate.py` mee aan en voer `/mcp reload` uit. Stop OMP, voer `unset GITHUB_MCP_TOKEN` uit in de oorspronkelijke terminal en trek het token in via GitHub Settings als het niet meer nodig is. Alleen de configuratie verwijderen trekt het token niet in.

Andere globale of geïmporteerde MCP-configuraties kunnen nog steeds servers toevoegen. Beoordeel iedere extra server afzonderlijk en volg het [OMP-schema](https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json). Zie ook de officiële [remote-serverdocumentatie](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md) en [authenticatievereisten](https://github.com/github/github-mcp-server/blob/main/docs/host-integration.md).

## Meerdere agenten

De baseline en alle profielen stellen `task.maxConcurrency: 3` in. OMP begrenst daarmee gelijktijdige subagents per sessie; de hoofdagent telt niet mee. Extra taken wachten op een vrij slot. Dit beperkt niet het totale aantal taken dat na elkaar kan worden uitgevoerd.

De instelling is geen globale grens over meerdere OMP-processen of geneste sessies en blijft wijzigbaar door processen met dezelfde rechten. De werkregels verbieden omzeiling via extra sessies, geneste delegatie of configuratiewijzigingen. Er is geen eigen orkestratielaag toegevoegd.

Controleer na een herstart van OMP met `make doctor`, of afzonderlijk met `PI_CONFIG_FILES=.omp/profiles/safe.yml omp config get task.maxConcurrency`. Verwacht `3`. Gebruik voor `config get` de omgevingsvariabele: OMP 18.1.17 geeft de launch-optie `--config` niet door aan dit subcommando. De interactieve launchers blijven `--config` gebruiken. Doe na OMP-upgrades een onschuldige proef met vier onafhankelijke taken: maximaal drie mogen tegelijk draaien. De statische validatie voert die modeltest niet uit.

De instelling en sessiescope zijn gecontroleerd in het [upstream schema](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/config/settings-schema.ts) en de [task-implementatie](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/task/index.ts).

Onafhankelijke analyses zoals review en documentatiecontrole kunnen zich lenen voor verdeling. Voor kleine edits geeft één agent vaak minder dubbel werk.

Geef iedere agent een afgebakende taak, voorkom gelijktijdige edits aan dezelfde bestanden en laat één verantwoordelijke integreren en testen. Controleer echte subagentgoedkeuringen: upstream beschrijft headless subagenten met YOLO-uitvoering en expliciete prompt-denies. SAFE bij de hoofdagent bewijst dus niet dat subagenten dezelfde bevestigingen vragen. Houd rekening met extra modelgebruik en accountlimieten.

## Menselijk onderhoudbare code

Kies betekenisvolle namen, samenhangende functies en duidelijke foutmeldingen. Vermijd cryptische one-liners en extra lagen zonder huidige noodzaak. Comments leggen vooral het waarom uit. Test zichtbaar gedrag en werk documentatie mee bij. AGENTS.md en .omp/RULES.md ondersteunen dit, maar menselijke review blijft nodig.
