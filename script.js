/* =====================================================================
   ÉLAN — site interactivity  (single shared file, loaded by every page)
   =====================================================================

   HOW THIS FILE IS ORGANISED
   --------------------------
   One IIFE runs on every page. Each block is page-safe: it guards its
   DOM targets, so a block whose elements aren't present simply does
   nothing. Blocks are grouped into lettered sections below; each banner
   names the PAGES that actually exercise it.

   Load order matters: helpers (A) and state/data (B,C,F,G) must stay
   above the blocks that use them, and INIT (Z) must stay last. Most
   feature blocks in between are independent.

   SECTION INDEX (in file order)
   -----------------------------
     A  CORE HELPERS ($, $$, storage, swatches) .... all pages
     B  CURRENCY (EUR base, live USD, fixed XOF) ... all pages
     C  LANGUAGE (EN / FR UI strings) .............. all pages
     D  STICKY NAV SHADOW .......................... all pages
     E  MOBILE NAV + MEGA TOGGLE ................... all pages
     F  CART STATE (localStorage) ................. all pages
     G  WISHLIST STATE (localStorage) ............. all pages
     H  HEADER BADGES (cart / wish counts) ........ all pages
     I  CART DRAWER (slide-out) ................... all pages
     J  ADD-TO-CART / WISH BUTTONS (delegated) .... listings, PDP, wishlist, gift-cards
     K  CART PAGE .................................. cart.html
     L  WISHLIST PAGE .............................. wishlist.html
     M  FILTERS + SORT ............................. collection pages
     N  SEARCH PAGE ................................ search.html
     O  ACCORDION .................................. faq, size-guide, PDP details
     P  SIZE-GUIDE UNIT TOGGLE ..................... size-guide.html
     Q  STORE LOCATOR FILTER ....................... store-locator.html
     R  PDP INTERACTIONS (gallery/swatch/size/qty) . product-*.html
     S  GIFT CARD CHIPS ............................ gift-cards.html
     T  GENERIC FORMS (.js-form) ................... contact, login, register, careers, newsletters
     U  ANNOUNCEMENT BAR ........................... all pages
     V  BACK TO TOP ................................ all pages
     W  SCROLL REVEAL .............................. home + company pages
     X  ANIMATED COUNTERS .......................... home + company pages (stats)
     Y  LANGUAGE / CURRENCY SELECTORS .............. all pages
     Z  INIT (first paint) ......................... all pages

   PER-PAGE INDEX (sections each page actually exercises — chrome =
   A-I,U,V,Y,Z which every page loads)
   ---------------------------------------------------------------------
     index.html (home) ............ chrome + W,X
     collection listings .......... chrome + J,M
     product-*.html (PDP) ......... chrome + J,O,R
     cart.html .................... chrome + K
     wishlist.html ................ chrome + J,L
     search.html .................. chrome + J,N
     faq.html ..................... chrome + O
     size-guide.html .............. chrome + O,P
     store-locator.html ........... chrome + Q
     gift-cards.html .............. chrome + J,S
     journal + journal-*.html ..... chrome + W
     about/careers/sustainability/
       press/membership ........... chrome + W,X
     contact/login/register ....... chrome + T
   ===================================================================== */
(function () {
  "use strict";

  /* ── A · CORE HELPERS ───────────────────────────────  Pages: all ── */
  const $ = (sel, ctx = document) => ctx.querySelector(sel);
  const $$ = (sel, ctx = document) => Array.from(ctx.querySelectorAll(sel));
  const read = (k, def) => { try { return JSON.parse(localStorage.getItem(k)) || def; } catch (e) { return def; } };
  const write = (k, v) => { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} };
  const SWATCH = { volt:"linear-gradient(150deg,#f6e1d6,#edc4b3)", crimson:"linear-gradient(150deg,#ff7a7a,#d0021b)", sky:"linear-gradient(150deg,#b9e6ff,#4aa8ff)", char:"linear-gradient(150deg,#4a4a4a,#1c1c1c)", rose:"linear-gradient(150deg,#ffd1e0,#ff7eb0)", mint:"linear-gradient(150deg,#c9f7e3,#4fd4a0)", black:"linear-gradient(150deg,#3a3a3a,#0c0c0c)", grey:"linear-gradient(150deg,#d6d6d6,#9a9a9a)" };
  const bg = (c) => SWATCH[c] || SWATCH.char;

  /* =========================================================
     B · CURRENCY                                  Pages: all
     base = EUR. XOF fixed to EUR by BCEAO parity
     (1 EUR = 655.957 XOF). USD pulled live with a fallback.
     ========================================================= */
  const FX = { EUR: 1, USD: 1.08, XOF: 655.957 };
  const CUR = { code: read("elan_cur", "EUR") };
  if (!FX[CUR.code]) CUR.code = "EUR";
  function fmt(eur) {
    const v = (Number(eur) || 0) * (FX[CUR.code] || 1);
    if (CUR.code === "XOF") return Math.round(v).toLocaleString("en-US") + " CFA";
    const sym = CUR.code === "USD" ? "$" : "€";
    return sym + v.toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }
  const euro = (n) => fmt(n); // cart/drawer/PDP money helper (currency-aware)

  // Re-price static product/PDP price labels (stored in EUR in markup)
  function localizePrices() {
    $$(".product__price, .pdp__price").forEach((el) => {
      if (el.dataset.eurHtml === undefined) el.dataset.eurHtml = el.innerHTML;
      el.innerHTML = el.dataset.eurHtml.replace(/€\s*([\d]+(?:\.[\d]+)?)/g, (m, n) => fmt(parseFloat(n)));
    });
  }
  function applyCurrency(code) {
    if (FX[code]) CUR.code = code;
    write("elan_cur", CUR.code);
    localizePrices();
    paintDrawer(); paintCartPage(); paintWishPage();
    const sel = $("#curSel"); if (sel) sel.value = CUR.code;
  }
  // Live EUR->USD (ECB via Frankfurter); XOF stays fixed. Falls back silently.
  function refreshRates() {
    try {
      fetch("https://api.frankfurter.app/latest?from=EUR&to=USD")
        .then((r) => r.json())
        .then((d) => { if (d && d.rates && d.rates.USD) { FX.USD = d.rates.USD; if (CUR.code === "USD") applyCurrency("USD"); } })
        .catch(() => {});
    } catch (e) {}
  }

  /* =========================================================
     C · LANGUAGE (EN / FR)                        Pages: all
     Translates UI strings by text match;
     deep page copy stays in its source language.
     ========================================================= */
  const FR = {
    "Find a Store":"Trouver une boutique","Help":"Aide","Join Us":"Rejoignez-nous","Sign In":"Connexion",
    "New & Featured":"Nouveautés","Men":"Homme","Women":"Femme","Crew":"Enfant","Sale":"Soldes",
    "Featured":"À la une","Shop":"Boutique","Collections":"Collections","Sport":"Sport","Inspiration":"Inspiration",
    "New Drops":"Nouveautés","Best Sellers":"Meilleures ventes","Signature":"Signature","Outerwear":"Vêtements d'extérieur",
    "Apparel":"Vêtements","Accessories":"Accessoires","Gift Cards":"Cartes cadeaux","Running":"Course",
    "Gym & Training":"Gym & Entraînement","For Producers":"Pour les producteurs","For Artists":"Pour les artistes",
    "Stage & Tour":"Scène & Tournée","DJs":"DJs","Vinyl & Merch":"Vinyles & Goodies","Journal":"Journal",
    "Lookbook":"Lookbook","Membership":"Adhésion","All Outerwear":"Tout l'extérieur","All Apparel":"Tous les vêtements",
    "Search":"Rechercher","Your Bag":"Votre panier","Subtotal":"Sous-total","View Bag & Checkout":"Voir le panier & payer",
    "Add to Bag":"Ajouter au panier","Remove":"Retirer","Your bag is empty.":"Votre panier est vide.",
    "Account":"Compte","Company":"Entreprise","Join The List":"Rejoindre la liste","Sign Up":"S'inscrire",
    "Secure payments":"Paiements sécurisés","Terms":"Conditions","Privacy":"Confidentialité","Cookies":"Cookies",
    "Accessibility":"Accessibilité","Help & FAQ":"Aide & FAQ","Order Status":"Suivi de commande",
    "Order History":"Historique","Shipping":"Livraison","Returns":"Retours","Size Guide":"Guide des tailles",
    "Contact":"Contact","My Account":"Mon compte","Wishlist":"Favoris","Track Order":"Suivre la commande",
    "About":"À propos","Careers":"Carrières","Sustainability":"Responsabilité","Press":"Presse","Stores":"Boutiques",
    "Shop":"Boutique","Explore":"Explorer","Join":"Rejoindre","New Drop":"Nouveauté","Active":"Sport",
    "Trending Now":"Tendances","Shop By Category":"Acheter par catégorie","Shop By Discipline":"Acheter par discipline",
    "From the Journal":"Depuis le Journal","What Artists Say":"Ce que disent les artistes","Need a Hand?":"Besoin d'aide ?",
    "FIRST TO THE DROP":"PREMIER SUR LE DROP","Free shipping over €75":"Livraison offerte dès 75 €",
    "30-day free returns":"Retours gratuits sous 30 jours","Carbon-neutral orders":"Commandes neutres en carbone",
    "Free membership":"Adhésion gratuite","See options":"Voir les options","How it works":"Comment ça marche",
    "Join us":"Rejoignez-nous","Move to Zero":"Move to Zero",
    "Summary":"Récapitulatif","Total":"Total","Free":"Offert","Checkout":"Payer","Bag":"Panier",
    "Start shopping →":"Commencer vos achats →",
  };
  const LANG = { code: read("elan_lang", "en") };
  let i18nNodes = null;
  function collectI18n() {
    i18nNodes = [];
    const w = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null);
    let n; while ((n = w.nextNode())) { const t = n.nodeValue.trim(); if (t && FR[t]) i18nNodes.push({ node: n, en: n.nodeValue }); }
  }
  function applyLang(lang) {
    collectI18n();
    i18nNodes.forEach(({ node, en }) => {
      const key = en.trim();
      node.nodeValue = lang === "fr" && FR[key] ? en.replace(key, FR[key]) : en;
    });
    document.documentElement.lang = lang;
    LANG.code = lang;
    write("elan_lang", lang);
    const sel = $("#langSel"); if (sel) sel.value = lang;
  }
  function syncUI() { localizePrices(); if (LANG.code === "fr") applyLang("fr"); }

  /* ── D · STICKY NAV SHADOW ──────────────────────────  Pages: all ── */
  const nav = $("#nav");
  if (nav) {
    const onScroll = () => nav.classList.toggle("scrolled", window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
  }

  /* ── E · MOBILE NAV + MEGA TOGGLE ───────────────────  Pages: all ── */
  const hamburger = $("#hamburger"), navMenu = $("#navMenu");
  if (hamburger && navMenu) {
    hamburger.addEventListener("click", () => navMenu.classList.toggle("open"));
    $$(".nav__item > a", navMenu).forEach((a) => {
      a.addEventListener("click", (e) => {
        if (window.matchMedia("(max-width: 860px)").matches && a.parentElement.querySelector(".mega")) {
          e.preventDefault();
          a.parentElement.classList.toggle("open");
        }
      });
    });
  }

  /* ── F · CART STATE (localStorage) ──────────────────  Pages: all ── */
  const CART_KEY = "elan_cart";
  const getCart = () => read(CART_KEY, []);
  const setCart = (c) => { write(CART_KEY, c); paintCounts(); paintDrawer(); paintCartPage(); syncUI(); };
  const cartCount = () => getCart().reduce((n, i) => n + i.qty, 0);
  const cartTotal = () => getCart().reduce((s, i) => s + i.price * i.qty, 0);

  function addToCart(item) {
    const cart = getCart();
    const key = item.id + "|" + (item.size || "") + "|" + (item.color || "");
    const found = cart.find((i) => i.id + "|" + (i.size || "") + "|" + (i.color || "") === key);
    if (found) found.qty += item.qty || 1;
    else cart.push({ id: item.id, name: item.name, price: item.price, img: item.img || "char", size: item.size || "", color: item.color || "", qty: item.qty || 1 });
    setCart(cart);
  }

  /* ── G · WISHLIST STATE (localStorage) ──────────────  Pages: all ── */
  const WISH_KEY = "elan_wishlist";
  const getWish = () => read(WISH_KEY, []);
  const setWish = (w) => { write(WISH_KEY, w); paintCounts(); paintWishButtons(); paintWishPage(); syncUI(); };
  function toggleWish(item) {
    let w = getWish();
    if (w.find((i) => i.id === item.id)) w = w.filter((i) => i.id !== item.id);
    else w.push(item);
    setWish(w);
  }

  /* ── H · HEADER BADGES (cart / wish counts) ─────────  Pages: all ── */
  function paintCounts() {
    const c = $("#cartCount"), w = $("#wishCount");
    if (c) { c.textContent = cartCount(); c.classList.toggle("show", cartCount() > 0); }
    if (w) { w.textContent = getWish().length; w.classList.toggle("show", getWish().length > 0); }
  }

  /* ── I · CART DRAWER (slide-out) ────────────────────  Pages: all ── */
  const drawer = $("#cartDrawer"), overlay = $("#drawerOverlay");
  function openDrawer() { if (drawer) { drawer.classList.add("open"); overlay && overlay.classList.add("open"); paintDrawer(); } }
  function closeDrawer() { if (drawer) { drawer.classList.remove("open"); overlay && overlay.classList.remove("open"); } }
  $$("[data-cart-open]").forEach((b) => b.addEventListener("click", openDrawer));
  $$("[data-cart-close]").forEach((b) => b.addEventListener("click", closeDrawer));
  overlay && overlay.addEventListener("click", closeDrawer);
  document.addEventListener("keydown", (e) => e.key === "Escape" && closeDrawer());

  function lineHtml(i, idx) {
    return `<div class="cart-line">
      <div class="cart-line__img" style="background:${bg(i.img)}"></div>
      <div><div class="cart-line__name">${i.name}</div>
      <div class="cart-line__meta">${[i.color, i.size && "Size " + i.size, "Qty " + i.qty].filter(Boolean).join(" · ")}</div>
      <button class="cart-line__rm" data-rm="${idx}">Remove</button></div>
      <div>${euro(i.price * i.qty)}</div></div>`;
  }
  function paintDrawer() {
    const box = $("#cartDrawerItems"); if (!box) return;
    const cart = getCart();
    box.innerHTML = cart.length ? cart.map(lineHtml).join("") : '<p class="cart-empty">Your bag is empty.</p>';
    const sub = $("#drawerSubtotal"); if (sub) sub.textContent = euro(cartTotal());
    $$("[data-rm]", box).forEach((b) => b.addEventListener("click", () => {
      const c = getCart(); c.splice(+b.dataset.rm, 1); setCart(c);
    }));
  }

  /* ── J · ADD-TO-CART / WISH BUTTONS (delegated) ──  Pages: listings,
        PDP, wishlist, gift-cards ── */
  document.addEventListener("click", (e) => {
    const add = e.target.closest("[data-add-to-cart]");
    if (add) {
      const ctx = add.closest("[data-pdp]");
      let size = add.dataset.size || "";
      if (ctx) {
        const sel = $(".size.active", ctx);
        size = sel ? sel.textContent.trim() : "";
        if ($(".sizes", ctx) && !size) {
          const note = $(".pdp__note", ctx); if (note) note.textContent = "Please select a size.";
          return;
        }
        const sw = $(".swatch.active", ctx);
        var color = sw ? sw.dataset.color : add.dataset.color || "";
        var qty = parseInt(($(".qty input", ctx) || {}).value, 10) || 1;
        var img = (sw && sw.dataset.img) || add.dataset.img || "char";
      }
      addToCart({ id: add.dataset.id, name: add.dataset.name, price: parseFloat(add.dataset.price),
        img: img || add.dataset.img, size: size, color: color || add.dataset.color, qty: qty || 1 });
      const fb = ctx ? $(".pdp__note", ctx) : null;
      if (fb) fb.textContent = "Added to bag ✔";
      else openDrawer();
    }
    const wb = e.target.closest("[data-wish]");
    if (wb) {
      toggleWish({ id: wb.dataset.id, name: wb.dataset.name, price: parseFloat(wb.dataset.price || 0), img: wb.dataset.img || "char", href: wb.dataset.href || "#" });
    }
  });
  function paintWishButtons() {
    const ids = getWish().map((i) => i.id);
    $$("[data-wish]").forEach((b) => b.classList.toggle("active", ids.includes(b.dataset.id)));
  }

  /* ── K · CART PAGE ──────────────────────────  Pages: cart.html ── */
  function paintCartPage() {
    const root = $("#cartPage"); if (!root) return;
    const cart = getCart();
    const list = $("#cartItems", root), sum = $("#cartSummary", root);
    if (!cart.length) { list.innerHTML = '<p class="cart-empty">Your bag is empty. <a href="new-releases.html">Start shopping →</a></p>'; if (sum) sum.style.display = "none"; return; }
    if (sum) sum.style.display = "";
    list.innerHTML = cart.map((i, idx) => `
      <div class="cart-line" style="grid-template-columns:72px 1fr auto auto;">
        <div class="cart-line__img" style="width:72px;height:72px;background:${bg(i.img)}"></div>
        <div><div class="cart-line__name">${i.name}</div>
          <div class="cart-line__meta">${[i.color, i.size && "Size " + i.size].filter(Boolean).join(" · ") || "One size"}</div>
          <button class="cart-line__rm" data-rm="${idx}">Remove</button></div>
        <div class="qty" data-qrow="${idx}"><button data-q="-1">−</button><input value="${i.qty}" readonly /><button data-q="1">+</button></div>
        <div style="font-weight:700">${euro(i.price * i.qty)}</div>
      </div>`).join("");
    const ship = cartTotal() >= 75 || cartTotal() === 0 ? 0 : 4.95;
    sum.innerHTML = `<h3>Summary</h3>
      <div class="row"><span>Subtotal</span><span>${euro(cartTotal())}</span></div>
      <div class="row"><span>Shipping</span><span>${ship ? euro(ship) : "Free"}</span></div>
      <div class="row" style="border-top:1px solid var(--line);padding-top:0.8rem;font-size:1.1rem"><span>Total</span><span>${euro(cartTotal() + ship)}</span></div>
      <button class="btn btn--block" id="checkoutBtn">Checkout</button>
      <p class="form-note" id="checkoutNote" style="text-align:center"></p>`;
    $$("[data-rm]", list).forEach((b) => b.addEventListener("click", () => { const c = getCart(); c.splice(+b.dataset.rm, 1); setCart(c); }));
    $$("[data-qrow]", list).forEach((row) => {
      $$("[data-q]", row).forEach((b) => b.addEventListener("click", () => {
        const c = getCart(); const i = c[+row.dataset.qrow];
        i.qty = Math.max(1, i.qty + parseInt(b.dataset.q, 10)); setCart(c);
      }));
    });
    const co = $("#checkoutBtn", sum);
    co && co.addEventListener("click", () => { $("#checkoutNote").textContent = "Demo checkout — order placed! ✔"; localStorage.removeItem(CART_KEY); paintCounts(); setTimeout(paintCartPage, 900); });
  }

  /* ── L · WISHLIST PAGE ──────────────────  Pages: wishlist.html ── */
  function paintWishPage() {
    const root = $("#wishPage"); if (!root) return;
    const w = getWish();
    root.innerHTML = w.length ? `<div class="product-grid">${w.map((i) => `
      <article class="product">
        <a href="${i.href}" class="product__media" style="background:${bg(i.img)}"></a>
        <h3><a href="${i.href}">${i.name}</a></h3>
        <p class="product__price">${euro(i.price)}</p>
        <div class="product__actions">
          <button class="btn btn--sm" data-add-to-cart data-id="${i.id}" data-name="${i.name}" data-price="${i.price}" data-img="${i.img}">Add to Bag</button>
          <button class="wish active" data-wish data-id="${i.id}" data-name="${i.name}" data-price="${i.price}" data-img="${i.img}" data-href="${i.href}" aria-label="Remove">♥</button>
        </div>
      </article>`).join("")}</div>` : '<p class="cart-empty">Your wishlist is empty. <a href="new-releases.html">Find something you love →</a></p>';
  }

  /* ── M · FILTERS + SORT ──────────────  Pages: collection pages ── */
  const shopMain = $("#shopMain");
  if (shopMain) {
    const grid = $(".product-grid", shopMain);
    const cards = $$(".product", grid);
    const countEl = $("#shopCount");
    const apply = () => {
      const active = {};
      $$("input[data-filter]:checked").forEach((c) => { (active[c.dataset.filter] = active[c.dataset.filter] || []).push(c.value); });
      let shown = 0;
      cards.forEach((card) => {
        const ok = Object.keys(active).every((key) => active[key].includes(card.dataset[key]));
        card.classList.toggle("is-hidden", !ok);
        if (ok) shown++;
      });
      if (countEl) countEl.textContent = shown + " item" + (shown === 1 ? "" : "s");
    };
    const sortSel = $("#sortSelect");
    const sort = () => {
      const v = sortSel ? sortSel.value : "featured";
      const arr = cards.slice();
      if (v === "low") arr.sort((a, b) => a.dataset.price - b.dataset.price);
      else if (v === "high") arr.sort((a, b) => b.dataset.price - a.dataset.price);
      else if (v === "name") arr.sort((a, b) => a.dataset.name.localeCompare(b.dataset.name));
      arr.forEach((c) => grid.appendChild(c));
    };
    $$("input[data-filter]").forEach((c) => c.addEventListener("change", apply));
    sortSel && sortSel.addEventListener("change", sort);
    apply();
  }

  /* ── N · SEARCH PAGE ──────────────────────  Pages: search.html ── */
  const searchInput = $("#searchInput");
  if (searchInput) {
    const grid = $("#searchGrid");
    const cards = grid ? $$(".product", grid) : [];
    const empty = $("#searchEmpty");
    const run = (q) => {
      q = (q || "").trim().toLowerCase();
      let shown = 0;
      cards.forEach((c) => {
        const hit = !q || (c.dataset.name + " " + (c.dataset.cat || "")).toLowerCase().includes(q);
        c.classList.toggle("is-hidden", !hit); if (hit) shown++;
      });
      if (empty) empty.style.display = shown ? "none" : "block";
      const h = $("#searchHeading"); if (h && q) h.textContent = `Results for “${q}”`;
    };
    const params = new URLSearchParams(window.location.search);
    if (params.get("q")) { searchInput.value = params.get("q"); run(params.get("q")); }
    searchInput.addEventListener("input", (e) => run(e.target.value));
  }

  /* ── O · ACCORDION ──────────  Pages: faq, size-guide, PDP details ── */
  $$(".acc-q").forEach((q) => q.addEventListener("click", () => q.closest(".acc-item").classList.toggle("open")));

  /* ── P · SIZE-GUIDE UNIT TOGGLE ──────────  Pages: size-guide.html ── */
  $$("[data-unit]").forEach((btn) => btn.addEventListener("click", () => {
    const unit = btn.dataset.unit;
    $$("[data-unit]").forEach((b) => b.classList.toggle("active", b.dataset.unit === unit));
    $$("[data-cm]").forEach((el) => el.style.display = unit === "cm" ? "" : "none");
    $$("[data-in]").forEach((el) => el.style.display = unit === "in" ? "" : "none");
  }));

  /* ── Q · STORE LOCATOR FILTER ───────  Pages: store-locator.html ── */
  const locInput = $("#locatorInput");
  if (locInput) {
    const stores = $$(".store");
    locInput.addEventListener("input", (e) => {
      const q = e.target.value.trim().toLowerCase();
      stores.forEach((s) => s.classList.toggle("is-hidden", q && !s.textContent.toLowerCase().includes(q)));
    });
  }

  /* ── R · PDP INTERACTIONS (gallery, swatches, sizes, qty) ──
        Pages: product-*.html ── */
  $$("[data-pdp]").forEach((pdp) => {
    const mainImg = $(".pdp__main-img", pdp);
    $$(".pdp__thumb", pdp).forEach((t) => t.addEventListener("click", () => {
      $$(".pdp__thumb", pdp).forEach((x) => x.classList.remove("active"));
      t.classList.add("active");
      if (mainImg && t.dataset.c) mainImg.style.background = bg(t.dataset.c);
    }));
    $$(".swatch", pdp).forEach((s) => s.addEventListener("click", () => {
      $$(".swatch", pdp).forEach((x) => x.classList.remove("active"));
      s.classList.add("active");
      if (mainImg && s.dataset.img) mainImg.style.background = bg(s.dataset.img);
    }));
    $$(".size", pdp).forEach((s) => s.addEventListener("click", () => {
      if (s.classList.contains("disabled")) return;
      $$(".size", pdp).forEach((x) => x.classList.remove("active"));
      s.classList.add("active");
      const note = $(".pdp__note", pdp); if (note) note.textContent = "";
    }));
    const qbox = $(".qty", pdp);
    if (qbox) {
      const input = $("input", qbox);
      $$("button", qbox).forEach((b) => b.addEventListener("click", () => {
        input.value = Math.max(1, (parseInt(input.value, 10) || 1) + parseInt(b.dataset.q || (b.textContent.includes("−") ? -1 : 1), 10));
      }));
    }
  });

  /* ── S · GIFT CARD CHIPS ────────────────  Pages: gift-cards.html ── */
  $$(".chips").forEach((group) => {
    $$(".chip", group).forEach((chip) => chip.addEventListener("click", () => {
      $$(".chip", group).forEach((c) => c.classList.remove("active"));
      chip.classList.add("active");
      const btn = group.parentElement.querySelector("[data-add-to-cart]");
      if (btn) { btn.dataset.price = chip.dataset.value; btn.dataset.name = "ÉLAN Gift Card " + euro(parseFloat(chip.dataset.value)); }
    }));
  });

  /* ── T · GENERIC FORMS (.js-form) ──────  Pages: contact, login,
        register, careers, newsletter forms ── */
  $$("form.js-form").forEach((form) => {
    const note = $(".form-note", form) || (form.parentElement && form.parentElement.querySelector(".newsletter__note, .form-note"));
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const email = form.querySelector('input[type="email"]');
      if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) { if (note) note.textContent = "Please enter a valid email address."; return; }
      form.reset();
      if (note) note.textContent = form.dataset.success || "Thank you — we'll be in touch.";
    });
  });

  /* ── U · ANNOUNCEMENT BAR ───────────────────────────  Pages: all ── */
  const anbar = $("#anbar");
  if (anbar) {
    if (localStorage.getItem("elan_anbar") === "closed") anbar.classList.add("hide");
    const x = $("[data-anbar-close]", anbar);
    if (x) x.addEventListener("click", () => { anbar.classList.add("hide"); try { localStorage.setItem("elan_anbar", "closed"); } catch (e) {} });
  }

  /* ── V · BACK TO TOP ────────────────────────────────  Pages: all ── */
  const toTop = $("#toTop");
  if (toTop) {
    const onTop = () => toTop.classList.toggle("show", window.scrollY > 600);
    onTop();
    window.addEventListener("scroll", onTop, { passive: true });
    toTop.addEventListener("click", () => window.scrollTo({ top: 0, behavior: "smooth" }));
  }

  /* ── W · SCROLL REVEAL ──────────────  Pages: home + company pages ── */
  const reveals = $$(".reveal");
  if (reveals.length) {
    if ("IntersectionObserver" in window) {
      const ro = new IntersectionObserver((entries) => {
        entries.forEach((e) => { if (e.isIntersecting) { e.target.classList.add("in"); ro.unobserve(e.target); } });
      }, { threshold: 0.12, rootMargin: "0px 0px -8% 0px" });
      reveals.forEach((el) => ro.observe(el));
    } else {
      reveals.forEach((el) => el.classList.add("in"));
    }
  }

  /* ── X · ANIMATED COUNTERS ───  Pages: home + company pages (stats) ── */
  const counters = $$("[data-count]");
  if (counters.length && "IntersectionObserver" in window) {
    const fmt = (v, target) => (Number.isInteger(target) ? Math.round(v) : v.toFixed(1));
    const co = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (!e.isIntersecting) return;
        const el = e.target;
        const target = parseFloat(el.dataset.count) || 0;
        const suffix = el.dataset.suffix || "";
        const dur = 1300;
        let startTs = null;
        const tick = (ts) => {
          if (startTs === null) startTs = ts;
          const p = Math.min(1, (ts - startTs) / dur);
          const eased = 1 - Math.pow(1 - p, 3);
          el.textContent = fmt(target * eased, target) + suffix;
          if (p < 1) requestAnimationFrame(tick);
        };
        requestAnimationFrame(tick);
        co.unobserve(el);
      });
    }, { threshold: 0.5 });
    counters.forEach((el) => co.observe(el));
  }

  /* ── Y · LANGUAGE / CURRENCY SELECTORS ──────────────  Pages: all ──
        (navigate between EN root and FR /fr/ mirror) */
  const onFr = location.pathname.includes("/fr/");
  LANG.code = onFr ? "fr" : "en";
  const langSel = $("#langSel"), curSel = $("#curSel");
  if (langSel) {
    langSel.value = LANG.code;
    langSel.addEventListener("change", (e) => {
      const file = location.pathname.split("/").pop() || "index.html";
      if (e.target.value === "fr" && !onFr) location.href = "fr/" + file;
      else if (e.target.value === "en" && onFr) location.href = "../" + file;
    });
  }
  if (curSel) { curSel.value = CUR.code; curSel.addEventListener("change", (e) => applyCurrency(e.target.value)); }

  /* ── Z · INIT (first paint) ─────────────────────────  Pages: all ── */
  paintCounts(); paintWishButtons(); paintDrawer(); paintCartPage(); paintWishPage();
  applyCurrency(CUR.code);                  // format all prices in stored currency
  if (onFr) applyLang("fr");                // translate JS-rendered strings on FR pages
  refreshRates();                           // pull live EUR->USD, refresh if active
})();
