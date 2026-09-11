# Architectuur en gemaakte keuzes

OMP Harness is een startomgeving, geen eigen AI-model en geen vervanging van OMP. De agent draait in een Linux-container; het model wordt op afstand aangesproken. Je host draait Docker Desktop en VS Code, niet een lokale OMP-installatie.

| Onderdeel | Waarom | Beperking |
| --- | --- | --- |
| Node/Debian-image | Bruikbare basis voor JS-ontwikkeling plus Linux-tools | Geen complete toolchain voor iedere taal |
| Gebruiker agent | Geen standaard rootrechten | Eigen bestanden en credentials blijven toegankelijk |
| Repository op /workspace | Dezelfde indeling op macOS en Windows | Alle inhoud is leesbaar en schrijfbaar |
| Named volume op /home/agent/.omp | Login en sessies behouden bij rebuild | Gevoelige persistente state, geen automatische encryptiegarantie |
| Make | Korte, vindbare commando's | Draait in de container, niet vereist op de host |
| Drie overlays | Eén baseline met expliciete approval-keuze | Geen afzonderlijke OS-sandbox per profiel |
| Optionele MCP-config | Geen projectservers standaard; gebruikers kiezen hun eigen integraties | Persoonlijke/globale discovery-bronnen apart beoordelen |
| Memory/autolearn uit | Minder onverwachte automatische state | Sessies en OAuth worden nog steeds opgeslagen |
| Rules en skills | Consistent, menselijk onderhoudbaar werk | Gedragsinstructies, geen harde garantie |

## Bestanden en verantwoordelijkheden

- `.devcontainer/Dockerfile`: packages, gebruiker, OMP-installatie en versie-smoketest.
- `.devcontainer/devcontainer.json`: mounts, resourcegrenzen en VS Code-startconfiguratie.
- `.devcontainer/post-create.sh`: herhaalbare initialisatie; bestaande .env blijft behouden.
- `.devcontainer/omp-*`: start altijd vanuit /workspace met de gekozen overlay en argumenten.
- `.devcontainer/doctor.sh`: controleert relevante containerkenmerken en effectieve modes.
- `.omp/config.yml`: gedeelde defaults; `.omp/profiles/`: verschillen per modus.
- `.omp/RULES.md`: actieve native regels; `.omp/policies/boundaries.md`: toelichting.
- `.omp/skills/`: coding-, data- en documentwerkwijzen, geen geïnstalleerde documentbibliotheken.
- `scripts/validate.py`: statische checks zonder modelrequests.
- `AGENTS.md`: bijdragen aan deze harness via branches en PR's.

## Goedkeuringen

| Profiel | Lezen | `write` | `edit`/patch | Bash/eval | Delete/move |
| --- | --- | --- | --- | --- | --- |
| SAFE | Automatisch | Prompt | Prompt | Prompt | Prompt |
| NORMAL | Automatisch | Automatisch | Prompt | Prompt | Prompt |
| YOLO | Automatisch | Automatisch | Doorgaans automatisch | Doorgaans automatisch | Doorgaans automatisch |

Expliciete deny/prompt-policies en toolgedrag kunnen deze samenvatting beperken. Browser en computer staan in alle overlays uit. Een goedgekeurd shellcommando kan zelf schrijven of verwijderen: de tabel is geen filesystem-ACL.

NORMAL vraagt bewust bevestiging voor iedere `edit`/patch: OMP kan daarmee ook bestanden verwijderen of hernoemen, zonder de afzonderlijke `delete`/`move`-policy te raadplegen. Gewone edits krijgen daarom eveneens een prompt. De `write`-tool blijft automatisch toegestaan en kan ook bestaande inhoud overschrijven; dit profiel beschermt niet tegen ieder gegevensverlies.

## Versies

OMP_REF is voorlopig leeg: builds volgen de nieuwste binary-release. Voor een herhaalbare installatie zet je een gecontroleerde release-tag rechtstreeks bij build.args.OMP_REF in devcontainer.json en commit je die keuze. De Dockerfile accepteert ook een build-arg. Het host-environment wordt anders gebruikt als override; start VS Code opnieuw vanuit die omgeving indien nodig.

De installer komt nog van upstream main; ook de basisimage en apt-packages zijn niet op digest/versie vastgezet. Een release-tag alleen maakt de hele build dus niet reproduceerbaar. Downloaden naar een bestand maakt inspectie mogelijk, maar is op zichzelf geen supply-chain-verificatie. Een volgende stap is installercommit plus SHA256 en image-digest pinnen, met een getest updateproces.

## Wijzigingen in deze eerste harness-versie

Naam en repositorylinks aangepast; bestaande licentie behouden; private werkdirectories en .env-varianten genegeerd; LF-regelafbrekingen vastgelegd; credentialvolume per Dev Container benoemd; strengere initiële credentialmaprechten; onbetrouwbare OAuth-statusclaim uit doctor verwijderd; logout-uitleg en statische validatie toegevoegd; beginnersdocumentatie opgesplitst. De humane codingregels blijven behouden. MCP blijft optioneel met een lege projectconfig en GitHub als documentatievoorbeeld; er zijn geen autonome multi-agent-configuraties geactiveerd.
