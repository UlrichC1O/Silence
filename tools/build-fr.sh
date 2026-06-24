#!/usr/bin/env bash
# =====================================================================
#  SILENCE — French site builder (assembles the fr/ mirror).
#  Run via:  bash tools/build.sh   (or only FR:  bash tools/build-fr.sh)
#
#  WHAT TO EDIT HERE (French versions):
#   • French nav text ................ the  NAV  block
#   • French footer text ............. the  FOOTER  block
#   • French page titles ............. the  MANIFEST  block
#   • French product labels/badges ... the LABELS= / BADGE= arrays
#   • French page bodies ............. edit files in  _content_fr/<slug>.html
#  (Product ids/prices/colours come from the English catalog and must
#   stay in sync — see README.md "Adding or changing a product".)
# =====================================================================
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DIR="$(cd "$HERE/.." && pwd)"
CT="$DIR/_content_fr"
OUT="$DIR/fr"
mkdir -p "$OUT"
cd "$DIR"

swatchcss(){ case "$1" in
 volt) echo "linear-gradient(150deg,#f6e1d6,#edc4b3)";;
 sky) echo "linear-gradient(150deg,#b9e6ff,#4aa8ff)";;
 char) echo "linear-gradient(150deg,#4a4a4a,#1c1c1c)";;
 rose) echo "linear-gradient(150deg,#ffd1e0,#ff7eb0)";;
 mint) echo "linear-gradient(150deg,#c9f7e3,#4fd4a0)";;
 black) echo "linear-gradient(150deg,#3a3a3a,#0c0c0c)";;
 grey) echo "linear-gradient(150deg,#d6d6d6,#9a9a9a)";;
 *) echo "linear-gradient(150deg,#4a4a4a,#1c1c1c)";; esac; }

# Master products (names/ids/prices identical to EN; labels in FR for related cards)
IDS=(studio-jacket pleated-trouser wool-overshirt studio-hoodie tour-tee bside-crew producer-cap canvas-tote run-tee gym-shorts track-pant flex-hoodie)
NAMES=("SILENCE Studio Jacket" "SILENCE Pleated Trouser" "SILENCE Wool Overshirt" "SILENCE Studio Hoodie" "SILENCE Tour Tee" "SILENCE B-Side Crewneck" "SILENCE Producer Cap" "SILENCE Canvas Tote" "SILENCE Run Tee" "SILENCE Gym Shorts" "SILENCE Track Pant" "SILENCE Flex Hoodie")
LABELS=("Vêtements d'extérieur" "Pantalon" "Surchemise" "Sweat à capuche" "T-shirt de tournée" "Sweat ras-du-cou" "Casquette" "Sac cabas" "Haut de course" "Short d'entraînement" "Pantalon de survêtement" "Sweat d'entraînement")
PRICES=(189.99 129.99 159.99 119.99 44.99 89.99 34.99 29.99 49.99 44.99 79.99 99.99)
SALES=("" "" "" "" 31.49 "" "" "" "" "" "" "")
COLORS=(char black sky mint rose grey volt black sky char black mint)
PDP=(product-air-max-pulse product-pegasus-41 product-invincible-3 product-tech-fleece-hoodie product-pro-dri-fit-tee product-sportswear-joggers product-air-max-pulse product-pro-dri-fit-tee product-run-tee product-gym-shorts product-track-pant product-flex-hoodie)
BADGE=("Nouveauté" "Nouveauté" "Nouveauté" "" "Solde" "" "" "" "Sport" "Sport" "Sport" "Sport")

pcard(){
  local i=$1 id=${IDS[$i]} name=${NAMES[$i]} label=${LABELS[$i]} price=${PRICES[$i]} sale=${SALES[$i]}
  local color=${COLORS[$i]} pdp=${PDP[$i]} badge=${BADGE[$i]}
  local dprice=$price priceHtml="€$price" tag=""
  if [ -n "$sale" ]; then dprice=$sale; priceHtml="<s>€$price</s> €$sale"; fi
  if [ "$badge" = "Solde" ]; then tag='<span class="tag tag--sale">Solde</span>'; elif [ -n "$badge" ]; then tag="<span class=\"tag\">$badge</span>"; fi
  cat <<CARD
      <article class="product">
        <a href="$pdp.html" class="product__media" style="background:$(swatchcss "$color")">$tag</a>
        <h3><a href="$pdp.html">$name</a></h3>
        <p class="product__cat">$label</p>
        <p class="product__price">$priceHtml</p>
        <div class="product__actions">
          <button class="btn btn--sm" data-add-to-cart data-id="$id" data-name="$name" data-price="$dprice" data-img="$color">Ajouter au panier</button>
          <button class="wish" data-wish data-id="$id" data-name="$name" data-price="$dprice" data-img="$color" data-href="$pdp.html" aria-label="Ajouter aux favoris">&#9825;</button>
        </div>
      </article>
CARD
}
related_section(){
  echo '  <section class="page-body" style="border-top:1px solid var(--line)">'
  echo '    <h2 style="margin-bottom:1.2rem">Vous aimerez aussi</h2>'
  echo '    <div class="product-grid">'
  for i in 0 2 5 7; do pcard "$i"; done
  echo '    </div>'
  echo '  </section>'
}

# ---------------- French NAV ----------------
read -r -d '' NAV <<'NAVEOF' || true
  <div class="util">
    <div class="util__left">SILENCE</div>
    <nav class="util__right">
      <select class="util__sel" id="langSel" aria-label="Langue"><option value="en">EN</option><option value="fr">FR</option></select><select class="util__sel" id="curSel" aria-label="Devise"><option value="EUR">€ EUR</option><option value="USD">$ Dollar</option><option value="XOF">CFA XOF</option></select><span>|</span>
      <a href="store-locator.html">Trouver une boutique</a><span>|</span>
      <a href="faq.html">Aide</a><span>|</span>
      <a href="register.html">Rejoignez-nous</a><span>|</span>
      <a href="login.html">Connexion</a>
    </nav>
  </div>
  <header class="nav" id="nav">
    <button class="hamburger" id="hamburger" aria-label="Ouvrir le menu">&#9776;</button>
    <a href="index.html" class="nav__logo" aria-label="Accueil SILENCE">
      <img src="logo-lockup.svg" alt="SILENCE" />
    </a>
    <nav class="nav__menu" id="navMenu">
      <div class="nav__item">
        <a href="new-releases.html">Nouveautés</a>
        <div class="mega">
          <div><h5>À la une</h5><a href="new-releases.html">Nouveautés</a><a href="best-sellers.html">Meilleures ventes</a><a href="air-max.html">Signature</a><a href="sale.html">Soldes</a></div>
          <div><h5>Boutique</h5><a href="shoes.html">Vêtements d'extérieur</a><a href="clothing.html">Vêtements</a><a href="accessories.html">Accessoires</a><a href="gift-cards.html">Cartes cadeaux</a></div>
          <div><h5>Collections</h5><a href="running.html">Pour les producteurs</a><a href="training.html">Pour les artistes</a><a href="lifestyle.html">Scène &amp; Tournée</a><a href="football.html">DJs</a><a href="basketball.html">Vinyles &amp; Goodies</a></div>
          <div><h5>Sport</h5><a href="run.html">Course</a><a href="gym.html">Gym &amp; Entraînement</a></div><div><h5>Inspiration</h5><a href="journal.html">Journal</a><a href="lookbook.html">Lookbook</a><a href="membership.html">Adhésion</a></div>
        </div>
      </div>
      <div class="nav__item">
        <a href="men.html">Homme</a>
        <div class="mega">
          <div><h5>À la une</h5><a href="new-releases.html">Nouveautés</a><a href="best-sellers.html">Meilleures ventes</a><a href="sale.html">Soldes</a></div>
          <div><h5>Extérieur</h5><a href="shoes.html">Tout l'extérieur</a><a href="running.html">Pour les producteurs</a><a href="training.html">Pour les artistes</a><a href="basketball.html">Vinyles &amp; Goodies</a></div>
          <div><h5>Vêtements</h5><a href="clothing.html">Tous les vêtements</a><a href="accessories.html">Accessoires</a></div>
        </div>
      </div>
      <div class="nav__item">
        <a href="women.html">Femme</a>
        <div class="mega">
          <div><h5>À la une</h5><a href="new-releases.html">Nouveautés</a><a href="best-sellers.html">Meilleures ventes</a><a href="sale.html">Soldes</a></div>
          <div><h5>Extérieur</h5><a href="shoes.html">Tout l'extérieur</a><a href="running.html">Pour les producteurs</a><a href="lifestyle.html">Scène &amp; Tournée</a></div>
          <div><h5>Vêtements</h5><a href="clothing.html">Tous les vêtements</a><a href="accessories.html">Accessoires</a></div>
        </div>
      </div>
      <a href="kids.html">Enfant</a>
      <a href="sale.html" class="is-sale">Soldes</a>
    </nav>
    <div class="nav__tools">
      <form class="search" action="search.html" method="get" role="search">
        <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" stroke-width="2"/><line x1="16.5" y1="16.5" x2="22" y2="22" stroke="currentColor" stroke-width="2"/></svg>
        <input type="search" name="q" placeholder="Rechercher" aria-label="Rechercher" />
      </form>
      <a href="wishlist.html" class="icon-btn" aria-label="Favoris">&#9825;<span class="badge" id="wishCount">0</span></a>
      <button class="icon-btn" data-cart-open aria-label="Panier" style="border:none;background:transparent;cursor:pointer;font-size:1.25rem;">&#9094;<span class="badge" id="cartCount">0</span></button>
      <a href="account.html" class="icon-btn" aria-label="Compte" style="font-size:1.2rem;">&#9737;</a>
    </div>
  </header>
  <div class="drawer-overlay" id="drawerOverlay" data-cart-close></div>
  <aside class="cart-drawer" id="cartDrawer" aria-label="Panier">
    <div class="cart-drawer__head"><h3>Votre panier</h3><button class="cart-drawer__close" data-cart-close aria-label="Fermer">&times;</button></div>
    <div class="cart-drawer__items" id="cartDrawerItems"></div>
    <div class="cart-drawer__foot">
      <div class="row"><span>Sous-total</span><span id="drawerSubtotal">€0.00</span></div>
      <a href="cart.html" class="btn btn--block">Voir le panier &amp; payer</a>
    </div>
  </aside>
NAVEOF

# ---------------- French FOOTER ----------------
read -r -d '' FOOTER <<'FOOTEREOF' || true
  <footer class="footer">
    <div class="footer__top">
      <div class="footer__brand">
        <a href="index.html" class="footer__logo" aria-label="Accueil SILENCE">
          <img src="logo-lockup-light.svg" alt="SILENCE" />
        </a>
        <p class="footer__tagline">Pour celles et ceux qui font le son. Vêtements et sagesse pour les musiciens — sinon, j'entends.</p>
        <div class="footer__social">
          <a href="https://www.instagram.com" target="_blank" rel="noopener noreferrer" aria-label="Instagram"><svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="4" stroke="currentColor" stroke-width="2"/><circle cx="17.5" cy="6.5" r="1.3" fill="currentColor"/></svg></a>
          <a href="https://www.tiktok.com" target="_blank" rel="noopener noreferrer" aria-label="TikTok"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M16 3c.3 2.1 1.5 3.6 3.6 3.9v2.4c-1.3.1-2.5-.3-3.6-1v5.9c0 3-2.1 5.3-5 5.3a5 5 0 0 1-5-5c0-2.9 2.3-5 5.2-4.9v2.5c-.3-.1-.6-.1-.9-.1a2.5 2.5 0 0 0 0 5c1.4 0 2.4-1.1 2.4-2.6V3H16Z"/></svg></a>
          <a href="https://x.com" target="_blank" rel="noopener noreferrer" aria-label="X"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M18.9 2H22l-7.6 8.7L23 22h-6.2l-4.9-6.4L6 22H2.9l8.1-9.3L2 2h6.4l4.4 5.8L18.9 2Z"/></svg></a>
          <a href="https://www.youtube.com" target="_blank" rel="noopener noreferrer" aria-label="YouTube"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M23 12s0-3.2-.4-4.7a2.5 2.5 0 0 0-1.8-1.8C19.3 5 12 5 12 5s-7.3 0-8.8.5A2.5 2.5 0 0 0 1.4 7.3C1 8.8 1 12 1 12s0 3.2.4 4.7a2.5 2.5 0 0 0 1.8 1.8C4.7 19 12 19 12 19s7.3 0 8.8-.5a2.5 2.5 0 0 0 1.8-1.8C23 15.2 23 12 23 12Zm-13 3V9l5 3-5 3Z"/></svg></a>
          <a href="https://www.facebook.com" target="_blank" rel="noopener noreferrer" aria-label="Facebook"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M14 9V7c0-1 .2-1.5 1.5-1.5H17V2.2C16.6 2.1 15.3 2 14.2 2 11.5 2 10 3.6 10 6.4V9H7.5v3H10v10h3.5V12H16l.5-3H14Z"/></svg></a>
        </div>
      </div>
      <form class="footer__news js-form" data-success="Vous êtes inscrit·e. Vérifiez votre boîte mail pour 10 € offerts. ✔">
        <h4>Rejoindre la liste</h4>
        <p>Accès anticipé aux drops, exclusivités membres et 10 € sur votre première commande.</p>
        <div class="footer__news-row">
          <input type="email" name="email" placeholder="Adresse e-mail" required aria-label="Adresse e-mail" />
          <button type="submit" class="btn">S'inscrire</button>
        </div>
        <p class="form-note" role="status"></p>
      </form>
    </div>

    <div class="footer__cols">
      <div><h4>Boutique</h4><a href="men.html">Homme</a><a href="women.html">Femme</a><a href="kids.html">Enfant</a><a href="new-releases.html">Nouveautés</a><a href="best-sellers.html">Meilleures ventes</a><a href="sale.html">Soldes</a></div>
      <div><h4>Collections</h4><a href="shoes.html">Vêtements d'extérieur</a><a href="clothing.html">Vêtements</a><a href="accessories.html">Accessoires</a><a href="running.html">Pour les producteurs</a><a href="training.html">Pour les artistes</a><a href="lifestyle.html">Scène &amp; Tournée</a><a href="run.html">Course</a><a href="gym.html">Gym &amp; Entraînement</a></div>
      <div><h4>Aide</h4><a href="faq.html">Aide &amp; FAQ</a><a href="shipping.html">Livraison</a><a href="returns.html">Retours</a><a href="order-status.html">Suivre la commande</a><a href="size-guide.html">Guide des tailles</a><a href="contact.html">Contact</a></div>
      <div><h4>Compte</h4><a href="account.html">Mon compte</a><a href="order-history.html">Historique</a><a href="wishlist.html">Favoris</a><a href="membership.html">Adhésion</a><a href="gift-cards.html">Cartes cadeaux</a></div>
      <div><h4>Entreprise</h4><a href="about.html">À propos</a><a href="sustainability.html">Responsabilité</a><a href="careers.html">Carrières</a><a href="press.html">Presse</a><a href="journal.html">Journal</a><a href="store-locator.html">Boutiques</a></div>
    </div>

    <div class="footer__bar">
      <div class="footer__bar-left">
        <span class="footer__region">&#127757; Europe (EUR €) &middot; Français</span>
        <span>&copy; 2026 SILENCE, Inc. Tous droits réservés.</span>
      </div>
      <nav class="footer__legal"><a href="terms.html">Conditions</a><a href="privacy.html">Confidentialité</a><a href="cookies.html">Cookies</a><a href="contact.html">Accessibilité</a></nav>
      <div class="footer__pay" aria-label="Moyens de paiement acceptés">
        <span class="footer__pay-label"><svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4" y="10.5" width="16" height="10.5" rx="2" fill="currentColor"/><path d="M7.5 10.5V7.5a4.5 4.5 0 0 1 9 0v3" stroke="currentColor" stroke-width="2"/></svg>Paiements sécurisés</span>
        <span class="pay-badge"><img src="pay-orange.svg" alt="Orange Money" loading="lazy" /></span><span class="pay-badge"><img src="pay-mtn.svg" alt="MTN MoMo" loading="lazy" /></span><span class="pay-badge"><img src="pay-wave.svg" alt="Wave" loading="lazy" /></span><span class="pay-badge"><img src="pay-djamo.svg" alt="Djamo" loading="lazy" /></span><span class="pay-badge"><img src="pay-push.svg" alt="Push" loading="lazy" /></span><span class="pay-badge pay-badge--text" title="Visa">VISA</span>
      </div>
    </div>
  </footer>
  <script src="script.js"></script>
</body>
</html>
FOOTEREOF

# ---------------- French manifest (slug<TAB>French title) ----------------
MANIFEST="air-max	Signature
new-releases	Nouveautés
best-sellers	Meilleures ventes
sale	Soldes
men	Homme
women	Femme
kids	Enfant
accessories	Accessoires
order-status	Suivi de commande
shipping	Livraison
returns	Retours
contact	Contact
about	À propos
careers	Carrières
sustainability	Responsabilité
press	Presse
terms	Conditions générales
privacy	Politique de confidentialité
cookies	Politique de cookies
shoes	Vêtements d'extérieur
clothing	Vêtements
running	Pour les producteurs
training	Pour les artistes
lifestyle	Scène & Tournée
football	DJs
basketball	Vinyles & Goodies
cart	Panier
wishlist	Favoris
search	Rechercher
size-guide	Guide des tailles
store-locator	Nos boutiques
gift-cards	Cartes cadeaux
membership	Adhésion
faq	Aide & FAQ
journal	Journal
journal-air-revolution	Le pouvoir du silence
journal-marathon-guide	Votre première sortie
journal-move-to-zero	Possédez vos masters
lookbook	Lookbook
account	Mon compte
login	Connexion
register	Rejoignez-nous
order-history	Historique des commandes
run	Course
gym	Gym & Entraînement
product-air-max-pulse	SILENCE Studio Jacket
product-pegasus-41	SILENCE Pleated Trouser
product-invincible-3	SILENCE Wool Overshirt
product-tech-fleece-hoodie	SILENCE Studio Hoodie
product-pro-dri-fit-tee	SILENCE Tour Tee
product-sportswear-joggers	SILENCE B-Side Crewneck
product-run-tee	SILENCE Run Tee
product-gym-shorts	SILENCE Gym Shorts
product-track-pant	SILENCE Track Pant
product-flex-hoodie	SILENCE Flex Hoodie"

# ---------------- Assemble FR pages ----------------
count=0; missing=0
while IFS=$'\t' read -r slug title; do
  [ -z "$slug" ] && continue
  frag="$CT/$slug.html"
  if [ ! -f "$frag" ]; then missing=$((missing+1)); echo "  !! MISSING fr fragment: $slug"; printf '  <section class="page-hero"><h1>%s</h1><p>Bientôt disponible.</p></section>\n' "$title" > "$frag"; fi
  {
    cat <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$title — SILENCE</title>
  <link rel="icon" type="image/svg+xml" href="logo.svg" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Anton&family=Chakra+Petch:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="styles.css" />
</head>
<body>
  <a class="skip-link" href="#content">Aller au contenu</a>
  <div class="anbar" id="anbar"><span>&#10038; Livraison offerte dès 75 € &middot; Rejoignez <a href="membership.html">Le Cercle SILENCE</a> pour l'accès anticipé &amp; 10 € offerts &rarr;</span><button class="anbar__x" data-anbar-close aria-label="Fermer">&times;</button></div>
EOF
    printf '%s\n' "$NAV"
    printf '  <main id="content">\n'
    cat "$frag"
    case "$slug" in product-*) related_section ;; esac
    printf '  </main>\n'
    printf '  <button class="to-top" id="toTop" aria-label="Haut de page">&uarr;</button>\n'
    printf '%s\n' "$FOOTER"
  } > "$OUT/$slug.html"
  count=$((count+1))
done <<< "$MANIFEST"

# ---------------- Fix asset paths for fr/ subdir (assets live one level up) ----------------
perl -i -pe 's{(href|src)="(styles\.css|script\.js|logo\.svg|logo-lockup\.svg|logo-lockup-light\.svg|pay-[a-z]+\.svg)"}{$1="../$2"}g' "$OUT"/*.html

echo "Assembled FR pages: $count (missing fragments: $missing)"
