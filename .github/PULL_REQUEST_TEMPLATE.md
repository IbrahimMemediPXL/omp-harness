## Waarom?

<!-- Welk probleem lost dit op en waarom is de wijziging nodig? -->

Gerelateerd issue: <!-- Bijvoorbeeld Closes #123, of n.v.t. met reden. -->

## Wat verandert?

<!-- Beschrijf de belangrijkste wijzigingen en het resulterende gedrag. -->

## Validatie

<!-- Noteer commando's én resultaten. Vermeld niet-uitgevoerde tests met reden. -->

| Controle | Resultaat / reden niet uitgevoerd |
| --- | --- |
| make validate | |
| Relevante gedragstests | |
| Container rebuild en make doctor (bij runtimewijzigingen) | |

## Risico's en compatibiliteit

<!-- Breaking changes, nieuwe dependencies/rechten, migratie of terugdraaien. Schrijf n.v.t. indien van toepassing. -->

## Reviewchecklist

- [ ] De wijziging is gericht, compact en begrijpelijk voor een menselijke maintainer.
- [ ] Documentatie en relevante tests passen bij het gewijzigde gedrag.
- [ ] Ik heb de diff gecontroleerd op secrets en onbedoelde bestanden.
- [ ] De limiet van drie gelijktijdige subagents en bestaande veiligheidsgrenzen blijven behouden.
- [ ] Niet-uitgevoerde controles en bekende beperkingen zijn hierboven vermeld.
