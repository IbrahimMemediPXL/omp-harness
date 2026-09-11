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

Controleer bij wijzigingen zowel .omp/config.yml als alle drie overlays in .omp/profiles/. Houd shell/eval-goedkeuring expliciet in safe en normal. Gebruik `make profiles` en test echte prompts met onschuldige edits en shellcommando's.

Raadpleeg de [upstream documentatie](https://github.com/can1357/oh-my-pi/tree/main/docs) voor sleutels die bij je OMP-versie horen. Verzin geen opties en versoepel geen beveiliging om een geblokkeerde taak alsnog te laten slagen.

## MCP

Er zijn standaard geen project-MCP-servers geconfigureerd. Voeg pas een server toe als bestaande lokale tools niet volstaan. Documenteer welke gegevens hij leest of wijzigt, externe systemen, credentials, minimale rechten, versie, tests en verwijderprocedure.

Volg het upstream schema voor .omp/mcp.json. Commit geen tokens. Een lege projectconfig sluit instellingen uit een bestaande globale OMP-map niet automatisch uit.

## Meerdere agenten

Deze repository configureert geen eigen multi-agentorkestratie. Onafhankelijke analyses zoals review en documentatiecontrole kunnen zich lenen voor verdeling. Voor kleine edits geeft één agent vaak minder dubbel werk.

Geef iedere agent een afgebakende taak, voorkom gelijktijdige edits aan dezelfde bestanden en laat één verantwoordelijke integreren en testen. Controleer echte subagentgoedkeuringen: upstream beschrijft headless subagenten met YOLO-uitvoering en expliciete prompt-denies. SAFE bij de hoofdagent bewijst dus niet dat subagenten dezelfde bevestigingen vragen. Houd rekening met extra modelgebruik en accountlimieten.

## Menselijk onderhoudbare code

Kies betekenisvolle namen, samenhangende functies en duidelijke foutmeldingen. Vermijd cryptische one-liners en extra lagen zonder huidige noodzaak. Comments leggen vooral het waarom uit. Test zichtbaar gedrag en werk documentatie mee bij. AGENTS.md en .omp/RULES.md ondersteunen dit, maar menselijke review blijft nodig.
