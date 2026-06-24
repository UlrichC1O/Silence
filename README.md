# Silence
Clothing brand
# SILENCE — site guide

A static, dependency-free storefront (clothing/fashion brand for musicians).
Bilingual (English + French), with EUR / USD / XOF currency switching.

There is **no framework and no install step** — it's plain HTML/CSS/JS. You edit
source files, run one build command, and refresh the browser.

---

## Quick start

```bash
bash tools/build.sh        # rebuild EN + FR and check all links
open index.html            # English homepage
open fr/index.html         # French homepage
```

Always run `tools/build.sh` after editing anything in `tools/` or `_content/`.
Editing `styles.css` or `script.js` needs **no rebuild** — just refresh.

---

## Where everything lives

```
maison-elan/
├── index.html            ← English homepage (edit directly, no build)
├── fr/                   ← French site (GENERATED — don't edit by hand)
├── *.html                ← English pages (GENERATED — don't edit by hand)
├── styles.css            ← ALL styling (edit directly)
├── script.js             ← ALL behaviour: cart, currency, language… (edit directly)
├── logo*.svg, pay-*.svg  ← logos & payment icons
├── _content/<slug>.html  ← English page BODIES you can hand-edit (source)
├── _content_fr/<slug>.html ← French page BODIES (source)
└── tools/
    ├── build.sh          ← run this: builds EN + FR + checks links
    ├── build-en.sh       ← English builder (catalog, nav, footer, titles)
    └── build-fr.sh       ← French builder (French nav/footer/labels)
```

> **Important:** the top-level `*.html` files and the whole `fr/` folder are
> **generated** by the build scripts. If you edit them directly they get
> overwritten on the next build. Edit the **sources** instead (below).

---

## What's a "source" vs "generated"?

| To change… | Edit this (source) | Generated result |
|---|---|---|
| Styling / colours / layout | `styles.css` | (used directly) |
| Behaviour (cart, currency, menu) | `script.js` | (used directly) |
| A product's name/price/colour | `tools/build-en.sh` arrays (+ FR labels in `tools/build-fr.sh`) | product cards everywhere |
| Nav menu text/links | `NAV` block in `build-en.sh` (+ `build-fr.sh` for FR) | nav on every page |
| Footer text/links | `FOOTER` block in `build-en.sh` (+ `build-fr.sh`) | footer on every page |
| Browser-tab titles | `MANIFEST` block in both build scripts | `<title>` of each page |
| Collection page intro text | `shoplisting "..."` lines in `build-en.sh` | e.g. `shoes.html` hero |
| A product/journal/company page's body copy | `_content/<slug>.html` (+ `_content_fr/<slug>.html`) | that page's main content |
| The homepage | `index.html` directly (+ `fr/index.html` for FR) | (used directly) |

---

## Recipes

### Change a product price or name
1. Open `tools/build-en.sh`, find the catalog arrays (search `IDS=`). Each
   product is one column, kept aligned across the arrays:
   `IDS NAMES LABELS PRICES SALES COLORS CCAT CGEN PDP BADGE`.
2. Edit the value in the matching column (e.g. a number in `PRICES`).
3. `bash tools/build.sh`.

> Prices are written in **EUR**; USD and XOF are converted automatically in the
> browser (XOF uses the fixed BCEAO parity 1 € = 655.957 CFA; USD uses a live rate).
> Don't add currency symbols in `PRICES` — just the number.

### Add a new product
1. Add one value to **each** array in `build-en.sh` (keep them aligned), and add
   the French category label/badge to the `LABELS=`/`BADGE=` arrays in
   `build-fr.sh`.
2. Point `PDP` at a product page slug (`product-...`). To give it a real detail
   page, create `_content/product-<slug>.html` and `_content_fr/product-<slug>.html`
   (copy an existing one as a template) and add the slug to the `MANIFEST` in
   both build scripts.
3. `bash tools/build.sh`.

### Edit the words in the top menu or footer
- English: edit the `NAV` / `FOOTER` block in `tools/build-en.sh`.
- French: edit the `NAV` / `FOOTER` block in `tools/build-fr.sh`.
- `bash tools/build.sh`.

### Edit a page's main text (e.g. a product description, an article, About)
- English: edit `_content/<slug>.html` (it's just the inner HTML of that page).
- French: edit `_content_fr/<slug>.html`.
- `bash tools/build.sh`.

### Change colours / fonts / spacing
- Edit `styles.css`. Brand tokens live at the very top under `:root`
  (`--volt` is the peach accent, `--ink`, `--brand` font, etc.). Refresh — no build.

### Currency rates
- In `script.js` search `FX`. `XOF` is the fixed BCEAO parity (don't change).
  `USD` is fetched live (Frankfurter/ECB) with a fallback number you can edit.

### Add a brand-new page
1. Create `_content/<slug>.html` (and `_content_fr/<slug>.html`).
2. Add `slug<TAB>Page Title` to the `MANIFEST` in `build-en.sh` (and `build-fr.sh`).
3. Link to it from `NAV`/`FOOTER` if you want it discoverable.
4. `bash tools/build.sh`.

---

## Language & currency
- The **EN/FR selector** (top bar) navigates between a page and its mirror, e.g.
  `men.html` ⇄ `fr/men.html`. Every English page has a French twin.
- The **currency selector** (EUR / $ Dollar / CFA XOF) reformats every price live.

## Good to know
- `tools/build.sh` ends by checking every internal link — keep it at
  "no broken links" after edits.
- `data-name` / `data-id` / `data-price` on product buttons must match across EN
  and FR (the cart relies on them) — that's why product *names* stay identical in
  both languages while only descriptions/labels are translated.
