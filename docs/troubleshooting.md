# Problemen oplossen

| Probleem | Controle en oplossing |
| --- | --- |
| Make of OMP niet gevonden | Gebruik de containerterminal; bekijk bij buildfouten de Dev Containers-log. |
| Docker start niet | Start Docker Desktop en controleer resources. Verwijder niet zomaar volumes. |
| OMP-download mislukt | Controleer netwerk/proxy en of OMP_REF een bestaande release met binary is. |
| Script geeft ^M of bad interpreter | Gebruik LF-regelafbrekingen zoals vastgelegd in .gitattributes. |
| Login opent geen browser | Open de getoonde URL zelf en volg de callbackinstructies in de beginnershandleiding. |
| Modellen zichtbaar, verzoek faalt | Modelcatalogus is geen logincheck. Controleer provider/account en meld opnieuw aan. Deel geen tokens. |
| Opnieuw aanmelden na nieuwe clone | Het credentialvolume is per devcontainer; een nieuwe clone kan een nieuw volume krijgen. |
| Permission denied op credentialvolume | Controleer gebruiker en eigendom. Een UID-wijziging kan een mismatch geven. Geen chmod -R 777 of blind verwijderen. |
| Skill aanwezig, package ontbreekt | Skills installeren geen dependencies; voeg ze toe aan projectomgeving of Dockerfile. |
| Werkbestanden niet in git status | Werkmappen zijn bewust genegeerd. Regel afzonderlijk versiebeheer of back-ups. |
| Doctor faalt buiten de container | Verwacht: gebruik make validate voor statische controles. |

## Grenzen van de tests

`make validate` vereist Python 3 met PyYAML, Bash, Git en Make. Het controleert configuratie, basisveiligheidsafspraken, shellsyntax, uitvoerrechten en ignorepatronen. Het bouwt Docker niet en controleert geen OAuth.

`make doctor` toetst de draaiende container, OMP en profielmodi. Controleer echte mounts en resourcegrenzen ook op de host met `docker inspect <containernaam>`. Verwijder gevoelige informatie voordat je uitvoer deelt.

## Handmatige smoketest

Bouw de devcontainer, voer doctor uit, meld aan en stel een kleine vraag. Vraag daarna in SAFE om een tijdelijk bestand en een onschuldig shellcommando. Controleer prompts en diff. Herbouw en controleer of aanmelden behouden blijft. Gebruik geen gevoelige input.

## Een probleem melden

Vermeld hostbesturingssysteem, OMP-versie, branch, relevante fout en minimale reproductiestappen. Verwijder callback-URLs, tokens, persoonsgegevens en bedrijfsinhoud. Publiceer geen credentialdatabase of volledige .env.
