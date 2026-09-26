# akeel-website — Velvet & Voltage

Reparatiesite voor **Velvet & Voltage**: reparatie en onderhoud van
koffiemachines en elektrische fietsen. Wat je hier bouwt, staat live op
**https://akeel.sdai.nl**.

## Hoe het werkt
- Alles in deze map draait in jouw container onder `/workspace/akeel-website`.
- Er draait automatisch een dev-server op **poort 3000** (zie `server.js`), die
  nginx doorzet naar `https://akeel.sdai.nl`.
- De **browser-IDE** staat op `https://ide-akeel.sdai.nl`.
- Het is één statische pagina (`index.html` + `assets/`). De server leest elk
  bestand bij elk verzoek opnieuw in, dus **na opslaan staat je wijziging direct
  live** — de server herstarten is alleen nodig als je `server.js` zelf aanpast.

## Starten / stoppen van de server
De container start de server automatisch. Wil je hem zelf draaien:

```bash
npm run dev          # = node server.js  (poort 3000)
```

Gebruik je een eigen framework (Vite, Next, Express, …)? Zorg dat het op
`0.0.0.0:3000` luistert, en zet zo nodig de auto-server uit met
`sudo supervisorctl stop appserver`.

## Wat staat waar

```
index.html               → de hele pagina (header, hero, diensten, werkwijze, over, contact, footer)
assets/css/style.css     → alle vormgeving; kleuren en lettertypes staan bovenin als variabelen
assets/js/app.js         → taalwissel EN/NL + het jaartal in de footer
favicon.svg              → het icoontje in het browsertabblad
robots.txt / sitemap.xml → vindbaarheid voor zoekmachines
server.js                → statische webserver op 0.0.0.0:3000 (niet aanpassen tenzij nodig)
```

## Eerst invullen: je contactgegevens

In de contactkaart (onderaan de pagina) staan nog placeholders. Vervang ze door
je eigen gegevens — **op twee plekken**, want de vertalingen staan in `app.js`:

| Wat | Waar |
| --- | --- |
| `[Your phone number]` / `Bellen of WhatsApp` | `index.html`, sectie `#contact` |
| `[Your email address]` / `E-mail` | `index.html`, sectie `#contact` |
| `[Your town or region]` / `Werkgebied` | `index.html`, sectie `#contact` |
| E-mailadres in de knop (`mailto:`) | `index.html` op `#email-cta` **én** `assets/js/app.js` (`setLanguage` → `email-cta`) |
| Hulpregel onder de knop (`placeholderNote`) | `assets/js/app.js`, bij `en:` en `nl:` |

> Vergeet de kleine regel onder de knop niet weg te halen zodra je gegevens
erin staan; die zegt nu nog dat je de gegevens moet vervangen.

## Tekst aanpassen

Elke tekst staat op twee plekken:

1. **`index.html`** — de tekst die bezoekers meteen zien. Elementen hebben een
   `data-i="..."`-label, bijvoorbeeld
   `<h1 data-i="heroTitle">Keep your<br>everyday <em>moving.</em></h1>`.
2. **`assets/js/app.js`** — het `translations`-object met dezelfde labels, apart
   voor `en:` en `nl:`. Dit is wat de taalwissel gebruikt.

Pas je een zin aan, doe dat dan in **beide** talen en in **beide** bestanden,
anders springt de tekst terug bij het wisselen van taal. De `data-i`-labels
moeten aan beide kanten exact gelijk blijven.

## Kleuren en lettertypes aanpassen

Bovenin `assets/css/style.css` staat één regel met alle variabelen:

```css
:root{--paper:#f5f3ec;--ink:#202a22;--muted:#657067;--green:#174735;--lime:#d7f36a;--line:#d9ddd4;--white:#fffefa;--serif:…;--sans:…}
```

`--green` (donkergroen) en `--lime` (accent) bepalen de hele uitstraling;
verander je die twee, dan kleurt de site mee. Het favicon (`favicon.svg`) gebruikt
dezelfde kleuren.

## Een extra taal toevoegen (bijvoorbeeld Duits)

1. Kopieer in `assets/js/app.js` het hele `en:{ … }`-blok naar `de:{ … }` en
   vertaal alleen de waarden (de labels links van de `:` laat je staan).
2. Zet in `index.html` een knop bij de andere taalknoppen, binnen
   `<div class="languages">`:
   `<button type="button" data-lang="de" aria-pressed="false">DE</button>`.

Meer is het niet: de knoppen, het onthouden van de keuze (localStorage,
sleutel `velvetVoltageLanguage`) en het wisselen van titel en omschrijving
gaan automatisch.

## Afbeeldingen toevoegen

Zet je bestanden in `assets/img/` en verwijs ernaar met
`<img src="/assets/img/bestand.jpg" alt="korte omschrijving" />`.
De illustraties in de hero en de kaarten zijn opgebouwd uit HTML/CSS en SVG,
dus die heb je niet nodig om de site te laten werken.

## Contactformulier

De knop “Stuur een reparatieaanvraag” opent het e-mailprogramma van de bezoeker
(`mailto:`), want de server serveert alleen statische bestanden. Een echte
formulier-service (Formspree, Netlify Forms) koppel je in `assets/js/app.js`:
vervang de `mailto:`-regel in `setLanguage` door een `fetch` naar je
formulier-endpoint.

## Je werk opslaan (git push)
De container heeft schrijfrechten op deze repo via een deploy-key:

```bash
git add -A
git commit -m "beschrijf je wijziging"
git push
```

Repo: `git@github.com:sayfjawad/akeel-website.git`
