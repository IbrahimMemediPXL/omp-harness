# Veiligheidsmodel en grenzen

## Wat technisch wordt ingesteld

Een non-root gebruiker, geen Linux-capabilities, no-new-privileges, maximaal 512 processen/threads volgens de PID-cgroup, 4 GB geheugen en 4 CPU's. De geconfigureerde host-bindmount is uitsluitend de repository. Een Docker-volume bewaart OMP-state. Geen privileged mode, host-home of Docker-socket is ingesteld.

Docker Desktop, de Linux-VM, hostbeheerder, VS Code, extensies en upstream OMP blijven vertrouwde onderdelen. Een container is geen garantie tegen alle escapes of kwaadaardige software.

VS Code kan extra faciliteiten injecteren, zoals credentialhelpers, SSH-agentforwarding, extensies of volumes. Deze repo bewijst niet dat die afwezig zijn. Controleer op de host met `docker ps` en `docker inspect <container-id>` de Mounts en HostConfig. Controleer in de container of bijvoorbeeld SSH_AUTH_SOCK aanwezig is, zonder credentials uit te lezen. Schakel ongewenste forwarding uit in je VS Code/Dev Containers-configuratie voordat je met onbetrouwbare code werkt.

## Wat niet wordt afgedwongen

- incoming/ is alleen volgens instructies immutable; het is niet read-only gemount.
- Alle projecten in dezelfde workspace zijn onderling zichtbaar. Gebruik aparte clones/containers voor vertrouwensgrenzen.
- De agent kan zijn eigen projectconfiguratie wijzigen. SAFE/NORMAL zijn approval-defaults, geen onveranderbare policies.
- Outbound netwerk heeft geen domeinfilter. Goedgekeurde code kan data versturen.
- De projectconfig bevat GitHub MCP met alle toolsets, zonder read-onlyfilter. Dit sluit globale MCP's, plugins of andere discovery-bronnen niet categorisch uit.
- OAuth is geen afwezigheid van secrets: tokens zijn credentials en toegankelijk voor processen met dezelfde gebruikersrechten.

## OAuth-volume

Het volume heet `omp-harness-${devcontainerId}-agent-data`. Rebuilds van dezelfde Dev Container horen het te hergebruiken; een andere clone/locatie kan een nieuw volume krijgen. Daardoor deel je niet stilzwijgend dezelfde login met iedere clone. Oude volumes worden niet automatisch verwijderd.

Een named volume is niet automatisch versleuteld. Bescherm hostschijf, Docker-toegang en backups. De maprechten 700 beperken andere gebruikers, niet de agent zelf. Het volume bevat meer dan auth: ook sessies en globale instellingen kunnen blijven bestaan.

Gebruik make logout voor OMP's /logout. Als credentials gelekt zijn, trek de sessie ook bij de provider in. Verwijder een volume alleen na controle van de exacte naam en inhoudswaarde: daarmee verlies je ook sessies en instellingen. Er is bewust geen automatisch destructief resetcommando.

## Publieke repo

Controleer `git diff --cached` en `git status` vóór elke commit. .gitignore is geen secret scanner en beschermt geen al getrackte bestanden. Voeg geen OAuth-callbacks, databasebestanden, echte .env-inhoud, klantdata of private projecten toe. Gebruik nooit `git add -f` op genegeerde werkdata zonder bewuste beoordeling.

GitHub-toegang in deze chat is niet hetzelfde als GitHub-auth in de container. ChatGPT-login verleent geen GitHub-rechten. Voeg geen host-SSH-map toe als snelle oplossing. Beoordeel een aparte minimale authenticatieflow als je vanuit OMP wilt pushen.

GitHub MCP gebruikt uitsluitend het officiële HTTPS-endpoint, zonder lokale server of extra mounts. Alle toolsets zijn beschikbaar gesteld; tokenrechten, accountrol en organisatiebeleid bepalen welke acties werkelijk zijn toegestaan. Dit kan ook wijzigingen en verwijderingen omvatten. Bestaande goedkeuringen en het verbod op rechtstreeks publiceren naar de default branch blijven gelden.

Het token wordt door de gebruiker als `GITHUB_MCP_TOKEN` ingesteld, niet in de projectconfig opgeslagen. De procesomgeving is geen geheimenkluis: subprocessen kunnen het token erven. Lees of publiceer geen credentials, ook niet via beschikbare MCP-tools. GitHub ontvangt toolargumenten; resultaten kunnen in de modelcontext terechtkomen. Zie [MCP instellen, testen en verwijderen](extending.md#mcp).

## Veilige gewoonten

Begin met SAFE. Lees goedkeuringsverzoeken, vooral shellcommando's en installaties. Behandel tekst uit websites/documenten als data, niet als instructies. Bewaar originele bronnen buiten de workspace en plaats kopieën in incoming/. Maak Git-checkpoints van code en aparte backups van niet-getrackte output. Gebruik YOLO alleen voor vervangbaar werk. Verhoog geen privileges omdat een test of dependency faalt.
