# Beginnen met OMP Harness

## 1. Download en open

Installeer Git, Docker Desktop, VS Code en de extensie **Dev Containers**. Start Docker Desktop. OMP en Make hoef je niet op je computer te installeren.

Voer op je computer uit zolang deze setup op de branch `initial` staat:

```sh
git clone --branch initial https://github.com/IbrahimMemediPXL/omp-harness.git
cd omp-harness
code .
```

Na het samenvoegen van de PR kun je de standaardbranch clonen. Zonder het code-commando: open de map via het menu van VS Code.

Kies **Dev Containers: Reopen in Container** via het commandopalet. De eerste build downloadt software en kan enkele minuten duren. Gebruik installatiescripts alleen als je de bron vertrouwt.

## 2. Controleer

Open een terminal in het containervenster:

```sh
pwd
whoami
make doctor
make validate
```

Verwacht `/workspace` en `agent`. Doctor controleert de omgeving, niet je login of alle veiligheidsproblemen. Statische validatie controleert bestanden en basisafspraken, niet modelgedrag.

Het opstartscript maakt werkmappen en een lokale .env aan. Voor ChatGPT-login hoef je daarin geen sleutel in te vullen. OMP laadt .env; de launchers voeren het bestand niet als shellscript uit.

## 3. Aanmelden zonder API-key

Start `make login`. Typ vervolgens **in OMP**, niet in de shell:

```text
/login openai-codex
```

Volg de URL en browserinstructies. Gebruik het bedoelde ChatGPT-account en kies de Business-workspace als de flow die keuze aanbiedt. Account- en organisatiebeperkingen kunnen toegang verhinderen; de harness omzeilt die niet.

Als de callback de container niet bereikt, volg de aanwijzingen van OMP. OMP ondersteunt de volledige redirect-URL via `/login <redirect-url>` in de actieve OMP-sessie. Behandel die URL als gevoelig: niet in issues, chat, screenshots of shellgeschiedenis plakken.

Kies via `/model` een beschikbaar model van de aangemelde provider. Doe een kleine proefvraag. Een modelcatalogus bewijst niet dat OAuth geldig is. ChatGPT-login meldt je ook niet automatisch aan bij GitHub.

## 4. Eerste opdracht

Start zo nodig `make safe` en probeer:

> Maak een klein Python-programma in projects/hello dat iemand begroet. Gebruik duidelijke namen en weinig afhankelijkheden. Voeg een korte README en een eenvoudige test toe. Vertel eerst welke bestanden je wijzigt. Voer niets buiten dit project uit.

Lees elke goedkeuringsvraag: pad, commando en netwerktoegang. Vraag bij twijfel om uitleg. Bekijk de bestanden en laat de test uitvoeren. Het resultaat in projects/ wordt niet automatisch door de harness gecommit of geback-upt.

## 5. Werkcyclus

1. Beschrijf resultaat, grenzen en acceptatiecriteria.
2. Laat relevante bestanden lezen en onduidelijkheden benoemen.
3. Werk in kleine veranderingen: eenvoudige code, geen toekomstige architectuur zonder actuele behoefte.
4. Bekijk de diff en voer gerichte tests uit.
5. Commit in de juiste projectrepository en gebruik een PR.

Voor de harness zelf: lees [CONTRIBUTING.md](../CONTRIBUTING.md). Sluiten van OMP is niet hetzelfde als uitloggen. `make logout` opent OMP met afmeldinstructies. Lees [veiligheid](security.md) voordat je gevoelige gegevens gebruikt.
