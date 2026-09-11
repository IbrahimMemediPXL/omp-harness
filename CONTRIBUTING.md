# Bijdragen

Werk op een featurebranch en stuur een pull request naar main. Push niet rechtstreeks naar de standaardbranch en herschrijf geen gedeelde geschiedenis. Lees eerst AGENTS.md en de relevante documentatie.

Houd veranderingen klein. Leg probleem, aanpak en werkelijk uitgevoerde tests uit in de PR. Vermeld beperkingen. Upgrades, integraties en permissiewijzigingen vereisen ook documentatie en een risicoafweging.

## Controles

Gebruik het issue-formulier om een bug, verbetering of documentatievraag te beschrijven. Vermeld het probleem, het gewenste resultaat en controleerbare acceptatiecriteria. Voor bugs: voeg reproductiestappen en omgevingsgegevens toe.

Het PR-template vraagt om de reden, veranderingen, gekoppeld issue, uitgevoerde tests en beperkingen. Vink alleen uitgevoerde controles af. De templates staan onder .github/ en worden na merge naar de standaardbranch beschikbaar voor nieuwe issues en PR's. Bestaande beschrijvingen worden niet automatisch aangepast.

In de devcontainer:

```sh
make validate
make doctor
git diff --check
git status --short
```

Statische validatie kan lokaal met Python 3, PyYAML, Bash, Make en Git. Gebruik een aparte Python-omgeving als PyYAML ontbreekt. Bij containerwijzigingen: herbouw en doe de runtime-smoketest uit [troubleshooting](docs/troubleshooting.md). Gebruik geen OAuth-credentials in CI of testfixtures.

Controleer voor commit welke bestanden meegaan. .gitignore is geen secret-scanner en beschermt geen reeds gevolgde bestanden. Gebruik synthetische testdata en behoud de bestaande licentie.

## Reviewvragen

- Zijn code en foutmeldingen begrijpelijk voor een nieuwe medewerker?
- Is de code compact zonder cryptische trucs?
- Heeft elke dependency of abstractie een huidige reden?
- Zijn gedrag, foutpaden, tests en handleiding bijgewerkt?
- Zijn credentials, mounts en goedkeuringsgrenzen behouden?

Een volgende stap is automatische PR-validatie en branchbescherming met verplichte review. Deze inrichting configureert die GitHub-instellingen niet. Laat ook periodiek een echte devcontainer-smoketest uitvoeren.
