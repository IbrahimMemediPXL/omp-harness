# Publiek bijdragen, main beheren

## Status en activering

Deze bestanden zijn een voorstel voor GitHub-instellingen. Alleen mergen activeert geen rulesets. Bij voorbereiding was de repo publiek, stonden issues en forks aan, en was main onbeschermd. De beschikbare GitHub-koppeling kan geen rulesets aanmaken of wijzigen.

1. Merge de PR met deze bestanden zodat .github/CODEOWNERS op main staat.
2. Download beide JSON-bestanden uit .github/rulesets/.
3. Open [Settings → Rules → Rulesets](https://github.com/IbrahimMemediPXL/omp-harness/settings/rules).
4. Kies bij New ruleset de importoptie en importeer elk JSON-bestand afzonderlijk.
5. Controleer vóór opslaan: status **Active**, target **main**. Bij main-admin-updates staat uitsluitend **Repository admin** op de bypasslijst, met **Always allow**. Bij main-preserve-history is de bypasslijst leeg.
6. Controleer na opslaan beide actieve regels in GitHub. De JSON-bestanden worden niet automatisch gesynchroniseerd: latere wijzigingen moeten opnieuw in de instellingen worden verwerkt.

Import vereist GitHub-adminrechten, maar geen API-key. GitHub ondersteunt [rulesets importeren als JSON](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository).

## Wie kan wat?

| Actie | Publieke bijdrager | Uitgenodigde collaborator | Admin/eigenaar |
| --- | --- | --- | --- |
| Code en branches bekijken | Ja | Ja | Ja |
| Issue openen of PR vanuit eigen fork maken | Ja, met GitHub-account | Ja | Ja |
| Branch in eigen fork maken | Ja | Ja | Ja |
| Branch rechtstreeks in deze repo maken | Nee | Ja, buiten main | Ja |
| Main pushen of PR naar main mergen, na activering | Nee | Nee | Ja |
| Vereiste code-owner-approval geven | Nee | Nee, tenzij de adminlijst wordt gewijzigd | Genoemde admin |
| Main verwijderen of force-pushen | Nee | Nee | Geblokkeerd zolang de aparte history-rule actief blijft |

Publiek betekent niet dat iedereen schrijfrechten krijgt. Iedereen kan eigen forkbranches gebruiken. Voor branches in deze repository moet de eigenaar mensen afzonderlijk als collaborator uitnodigen; er is geen openbare instelling die alle internetgebruikers automatisch collaborator maakt. Er zijn geen uitnodigingen verstuurd.

Dit is een persoonlijke repository: de eigenaar is IbrahimMemediPXL. Voor meerdere beheerders met aparte rollen is een GitHub-organisatie geschikt; migratie is niet onderdeel van deze wijziging. Zie [persoonlijke repositoryrechten](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository).

## Reviews en de adminuitzondering

CODEOWNERS wijst alle bestanden, inclusief zichzelf, aan @IbrahimMemediPXL toe. GitHub gebruikt de versie op de doelbranch. Samen met Require review from Code Owners maakt dit de review van die eigenaar vereist in de normale PR-flow. Andere gebruikers mogen nog reviews en approvals indienen; die vervangen de code-owner-goedkeuring niet. CODEOWNERS volgt adminrollen niet automatisch: werk de lijst bij als het beheer verandert. Zie [GitHub code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners).

De update-regel blokkeert wijzigingen aan main voor iedereen zonder admin-bypass, ook nadat een PR is goedgekeurd. De admin kan wel mergen en, zoals gevraagd, rechtstreeks pushen. Omdat deze bypass **Always allow** is, kan een admin ook zonder de vereiste review mergen. Dit is dus controle door de admin, geen technisch verplichte tweede adminhandtekening.

Een PR-auteur kan zijn eigen PR niet goedkeuren. Als enige eigenaar gebruik je voor eigen PR's de expliciete admin-bypass na controle. Wil je ook admins verplicht langs een onafhankelijke review sturen, dan zijn een tweede bevoegde reviewer en een andere bypassinrichting nodig.

De afzonderlijke history-rule heeft geen bypass en blokkeert force-push en verwijderen ook voor admins. Admins kunnen nog steeds repositoryregels wijzigen; regels kunnen de eigenaar niet permanent buitensluiten.

## Controle na activering

- Controleer dat beide rulesets Active zijn en alleen refs/heads/main targeten.
- Controleer dat GitHub CODEOWNERS zonder fouten herkent en de eigenaar als reviewer aanwijst bij een PR van iemand anders.
- Laat een bestaande niet-admincollaborator controleren dat featurebranches werken en mergen naar main geblokkeerd blijft, ook na eigenaarapproval.
- Controleer met een publieke bijdrager dat een issue en een PR vanuit een fork kunnen worden geopend. Accountblokkades of tijdelijke interactiebeperkingen kunnen deelname afzonderlijk beperken.
- Test geen destructieve push op main. Inspecteer de actieve history-regel.

Technische velddefinities: [GitHub Rules REST API](https://docs.github.com/en/rest/repos/rules). De bestanden zijn lokaal op structuur gecontroleerd; GitHub-import en afdwinging moeten na activering worden gecontroleerd.
