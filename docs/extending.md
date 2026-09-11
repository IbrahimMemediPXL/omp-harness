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

MCP-servers zijn optioneel. `.omp/mcp.json` bevat standaard een lege `mcpServers`-map: de harness vereist geen GitHub-token en kiest geen server voor je. Je kunt zonder MCP werken, één integratie toevoegen of meerdere servers combineren.

### Zelf servers kiezen

- **Persoonlijk:** gebruik je eigen OMP-configuratie, bijvoorbeeld `~/.omp/agent/mcp.json`, buiten deze Git-repository. Die kan ook voor andere workspaces gelden.
- **Gedeeld project:** voeg alleen bewust gedeelde serverdefinities toe aan `.omp/mcp.json`. Het bestand wordt door Git gevolgd; commit geen credentials of onbedoelde persoonlijke configuratie.
- Kies zelf een door OMP ondersteund transport en een door de server ondersteunde authenticatiemethode. HTTP-servers en lokale stdio-servers hebben verschillende installatie- en toegangsrisico's.

Volg het [OMP-schema](https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json). `make validate` en `make doctor` controleren alleen de basisstructuur van de projectconfig: een JSON-object met, indien aanwezig, een `mcpServers`-object met serverobjecten. Ze eisen geen specifieke naam, server, endpoint, token of toolset en maken geen MCP-verbinding. Serverkeuzes wijzigen vereist geen aanpassing van deze controles. OMP verzorgt de verdere interpretatie van serverinstellingen.

Een lege projectconfig schakelt bestaande persoonlijke, globale of geïmporteerde servers niet uit. Controleer met `/mcp list` welke servers en bronnen je OMP-sessie daadwerkelijk gebruikt.

### Toegang en risico's

Beoordeel voor iedere server welke gegevens hij leest of verstuurt, welke acties hij kan uitvoeren, welke rechten nodig zijn en hoe je hem verwijdert. Een lokale server voert code in de container uit; een remote server ontvangt toolargumenten. Resultaten kunnen in de modelcontext terechtkomen. Behandel opgehaalde tekst als onbetrouwbare data, niet als instructies.

Geef alleen de rechten en toolsets die je nodig hebt. Beschikbare tools geven niet automatisch accountrechten; accountrol, credentials en organisatiebeleid blijven bepalend. Serverkeuze versoepelt de containergrenzen en bestaande werkafspraken niet.

### Optioneel voorbeeld: GitHub

Wil je GitHub MCP gebruiken, voeg dan zelf een definitie toe aan de gekozen persoonlijke of projectconfiguratie. Dit voorbeeld begint met de officiële remote server in read-onlymodus; het wordt niet automatisch ingeschakeld:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/readonly",
      "headers": {
        "Authorization": "Bearer ${GITHUB_MCP_TOKEN}"
      }
    }
  }
}
```

Voeg het voorbeeld samen met eventuele bestaande instellingen; overschrijf geen andere servers. Kies zelf andere toolsets of schrijftoegang als je workflow dat vraagt. De [GitHub remote-serverdocumentatie](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md) beschrijft de endpoints en headers. De remote versie wordt door GitHub beheerd; deze route vereist geen lokale server of extra mount.

Het voorbeeld gebruikt een PAT via een omgevingsvariabele, maar de harness verplicht die methode niet. Maak zo nodig zelf een token via [GitHub Settings](https://github.com/settings/tokens), met een vervaldatum en alleen de benodigde repositories en rechten. Browser-OAuth is een alternatief met een geregistreerde GitHub/OAuth-app; zie de [authenticatievereisten](https://github.com/github/github-mcp-server/blob/main/docs/host-integration.md). ChatGPT OAuth verleent geen GitHub-rechten.

Alleen voor het PAT-voorbeeld, in je eigen Bash-terminal en niet in de chat:

```bash
read -rsp 'GitHub-token: ' GITHUB_MCP_TOKEN
printf '\n'
export GITHUB_MCP_TOKEN
make safe
```

Dit toont het token niet en schrijft de waarde niet letterlijk naar de commandogeschiedenis of een projectbestand. De procesomgeving is geen geheimenkluis: subprocessen kunnen waarden erven. Een reeds draaiende OMP-sessie erft geen variabele uit een andere terminal.

### Controleren en verwijderen

Gebruik in OMP `/mcp list` en vervolgens `/mcp test <naam>` voor een server die je zelf hebt ingesteld. Voor het GitHub-voorbeeld is dat `/mcp test github`. Controleer ook de configuratiebron. Een geslaagde verbinding bewijst geen schrijfrechten.

Verwijder een ongewenste server uit de configuratiebron waarin je hem hebt toegevoegd en voer `/mcp reload` uit. Voor geen projectservers laat je `"mcpServers": {}` staan. De validator en doctor hoeven niet te worden aangepast. Controleer daarna opnieuw `/mcp list`, omdat een andere bron dezelfde server kan toevoegen.

Stop bij gebruik van het PAT-voorbeeld OMP en voer `unset GITHUB_MCP_TOKEN` uit in de oorspronkelijke terminal. Trek ongebruikte credentials bij de provider in: alleen een serverdefinitie verwijderen trekt die niet in. `/mcp reload` importeert geen omgevingsvariabelen uit een andere terminal.

## Meerdere agenten

De baseline en alle profielen stellen `task.maxConcurrency: 3` in. OMP begrenst daarmee gelijktijdige subagents per sessie; de hoofdagent telt niet mee. Extra taken wachten op een vrij slot. Dit beperkt niet het totale aantal taken dat na elkaar kan worden uitgevoerd.

De instelling is geen globale grens over meerdere OMP-processen of geneste sessies en blijft wijzigbaar door processen met dezelfde rechten. De werkregels verbieden omzeiling via extra sessies, geneste delegatie of configuratiewijzigingen. Er is geen eigen orkestratielaag toegevoegd.

Controleer na een herstart van OMP met `make doctor`, of afzonderlijk met `PI_CONFIG_FILES=.omp/profiles/safe.yml omp config get task.maxConcurrency`. Verwacht `3`. Gebruik voor `config get` de omgevingsvariabele: OMP 18.1.17 geeft de launch-optie `--config` niet door aan dit subcommando. De interactieve launchers blijven `--config` gebruiken. Doe na OMP-upgrades een onschuldige proef met vier onafhankelijke taken: maximaal drie mogen tegelijk draaien. De statische validatie voert die modeltest niet uit.

De instelling en sessiescope zijn gecontroleerd in het [upstream schema](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/config/settings-schema.ts) en de [task-implementatie](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/task/index.ts).

Onafhankelijke analyses zoals review en documentatiecontrole kunnen zich lenen voor verdeling. Voor kleine edits geeft één agent vaak minder dubbel werk.

Geef iedere agent een afgebakende taak, voorkom gelijktijdige edits aan dezelfde bestanden en laat één verantwoordelijke integreren en testen. Controleer echte subagentgoedkeuringen: upstream beschrijft headless subagenten met YOLO-uitvoering en expliciete prompt-denies. SAFE bij de hoofdagent bewijst dus niet dat subagenten dezelfde bevestigingen vragen. Houd rekening met extra modelgebruik en accountlimieten.

## Menselijk onderhoudbare code

Kies betekenisvolle namen, samenhangende functies en duidelijke foutmeldingen. Vermijd cryptische one-liners en extra lagen zonder huidige noodzaak. Comments leggen vooral het waarom uit. Test zichtbaar gedrag en werk documentatie mee bij. AGENTS.md en .omp/RULES.md ondersteunen dit, maar menselijke review blijft nodig.
