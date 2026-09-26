# akeel-website

Jouw project voor de AI-training. Wat de agent hier bouwt, wordt live gezet op
**https://akeel.sdai.nl**.

## Hoe het werkt
- Alles in deze map draait in jouw container onder `/workspace/akeel-website`.
- Er draait automatisch een dev-server op **poort 3000** (zie `server.js`), die
  nginx doorzet naar `https://akeel.sdai.nl`.
- De **browser-IDE** staat op `https://ide-akeel.sdai.nl`.

## Starten / stoppen van de server
De container start de server automatisch. Wil je hem zelf draaien:

```bash
npm run dev          # = node server.js  (poort 3000)
```

Gebruik je een eigen framework (Vite, Next, Express, …)? Zorg dat het op
`0.0.0.0:3000` luistert, en zet zo nodig de auto-server uit met
`sudo supervisorctl stop appserver`.

## Je werk opslaan (git push)
De container heeft schrijfrechten op deze repo via een deploy-key:

```bash
git add -A
git commit -m "beschrijf je wijziging"
git push
```

Repo: `git@github.com:sayfjawad/akeel-website.git`

## Wat staat waar

```
index.html              → de hele pagina (header, hero, over, diensten, werk, contact, footer)
favicon.svg             → het icoontje in het browsertabblad
robots.txt / sitemap.xml→ vindbaarheid voor zoekmachines
server.js               → statische webserver op 0.0.0.0:3000 (niet aanpassen tenzij nodig)
assets/css/style.css    → alle vormgeving; kleuren/afstanden via de variabelen bovenin
assets/js/app.js        → mobiel menu, header bij scrollen, contactformulier
```

## Tekst aanpassen

In `index.html` staat jouw inhoud tussen vierkante haken, bijvoorbeeld `[jouw slogan]`.
Zoek die haken en vervang ze door je eigen tekst. Let op deze plekken:

| Wat | Waar in `index.html` |
| --- | --- |
| Titel + omschrijving (Google, tab) | `<title>` en `<meta name="description">` |
| Naam + slogan in de header | `.brand-name` |
| Introductie | de `hero`-sectie |
| Over jou | sectie `#over` (`.checklist` + `.facts`) |
| Diensten | sectie `#diensten` (kopieer een `<article class="card">`) |
| Projecten | sectie `#werk` (kopieer een `<article class="project">`) |
| E-mailadres | `data-email` op het formulier én de `mailto:`-link |
| Socials | de links in `.socials` |

Kleuren pas je aan in `assets/css/style.css`: bovenaan staan `--accent`, `--bg`, `--radius`, enz.

## Afbeeldingen toevoegen

Zet je bestanden in `assets/img/` en verwijs ernaar met
`<img src="/assets/img/bestand.jpg" alt="korte omschrijving" />`.

## Contactformulier

Het formulier opent het e-mailprogramma van de bezoeker (mailto), want de server
serveert alleen statische bestanden. Een echte formulier-service (Formspree,
Netlify Forms) koppel je in `assets/js/app.js` aan in het `submit`-blok.
