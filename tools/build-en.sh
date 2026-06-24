#!/usr/bin/env bash
# =====================================================================
#  SILENCE — English site builder.  Run via:  bash tools/build.sh
#  (builds EN + FR + checks links). EN only:    bash tools/build-en.sh
#
#  WHAT TO EDIT HERE (search for these):
#   • Products / prices / colours .... the IDS= / NAMES= / PRICES= ... arrays
#   • Top navigation + mega-menus .... the  NAV  block
#   • Footer links + columns ......... the  FOOTER  block
#   • Page titles (browser tab) ...... the  MANIFEST  block
#   • Collection page text ........... the  shoplisting "..."  lines
#   • Rich page bodies (product/journal/
#     company copy) ................... edit files in  _content/<slug>.html
#  Styling -> styles.css   Behaviour/JS -> script.js   Full guide -> README.md
# =====================================================================
set -uo pipefail
DIR="/Users/mac/maison-elan"
CT="$DIR/_content"
mkdir -p "$CT"
cd "$DIR"

swatchcss(){ case "$1" in
 volt) echo "linear-gradient(150deg,#f6e1d6,#edc4b3)";;
 crimson) echo "linear-gradient(150deg,#ff7a7a,#d0021b)";;
 sky) echo "linear-gradient(150deg,#b9e6ff,#4aa8ff)";;
 char) echo "linear-gradient(150deg,#4a4a4a,#1c1c1c)";;
 rose) echo "linear-gradient(150deg,#ffd1e0,#ff7eb0)";;
 mint) echo "linear-gradient(150deg,#c9f7e3,#4fd4a0)";;
 black) echo "linear-gradient(150deg,#3a3a3a,#0c0c0c)";;
 grey) echo "linear-gradient(150deg,#d6d6d6,#9a9a9a)";;
 *) echo "linear-gradient(150deg,#4a4a4a,#1c1c1c)";; esac; }

# ---------------- Canonical NAV ----------------
read -r -d '' NAV <<'NAVEOF' || true
  <div class="util">
    <div class="util__left">SILENCE</div>
    <nav class="util__right">
      <select class="util__sel" id="langSel" aria-label="Language"><option value="en">EN</option><option value="fr">FR</option></select><select class="util__sel" id="curSel" aria-label="Currency"><option value="EUR">€ EUR</option><option value="USD">$ Dollar</option><option value="XOF">CFA XOF</option></select><span>|</span>
            <a href="store-locator.html">Find a Store</a><span>|</span>
      <a href="faq.html">Help</a><span>|</span>
      <a href="register.html">Join Us</a><span>|</span>
      <a href="login.html">Sign In</a>
    </nav>
  </div>
  <header class="nav" id="nav">
    <button class="hamburger" id="hamburger" aria-label="Open menu">&#9776;</button>
    <a href="index.html" class="nav__logo" aria-label="SILENCE home">
      <img src="logo-lockup.svg" alt="SILENCE" />
    </a>
    <nav class="nav__menu" id="navMenu">
      <div class="nav__item">
        <a href="new-releases.html">New &amp; Featured</a>
        <div class="mega">
          <div><h5>Featured</h5><a href="new-releases.html">New Drops</a><a href="best-sellers.html">Best Sellers</a><a href="air-max.html">Signature</a><a href="sale.html">Sale</a></div>
          <div><h5>Shop</h5><a href="shoes.html">Outerwear</a><a href="clothing.html">Apparel</a><a href="accessories.html">Accessories</a><a href="gift-cards.html">Gift Cards</a></div>
          <div><h5>Collections</h5><a href="running.html">For Producers</a><a href="training.html">For Artists</a><a href="lifestyle.html">Stage &amp; Tour</a><a href="football.html">DJs</a><a href="basketball.html">Vinyl &amp; Merch</a></div>
          <div><h5>Sport</h5><a href="run.html">Running</a><a href="gym.html">Gym &amp; Training</a></div><div><h5>Inspiration</h5><a href="journal.html">Journal</a><a href="lookbook.html">Lookbook</a><a href="membership.html">Membership</a></div>
        </div>
      </div>
      <div class="nav__item">
        <a href="men.html">Men</a>
        <div class="mega">
          <div><h5>Featured</h5><a href="new-releases.html">New Drops</a><a href="best-sellers.html">Best Sellers</a><a href="sale.html">Sale</a></div>
          <div><h5>Outerwear</h5><a href="shoes.html">All Outerwear</a><a href="running.html">For Producers</a><a href="training.html">For Artists</a><a href="basketball.html">Vinyl &amp; Merch</a></div>
          <div><h5>Apparel</h5><a href="clothing.html">All Apparel</a><a href="accessories.html">Accessories</a></div>
        </div>
      </div>
      <div class="nav__item">
        <a href="women.html">Women</a>
        <div class="mega">
          <div><h5>Featured</h5><a href="new-releases.html">New Drops</a><a href="best-sellers.html">Best Sellers</a><a href="sale.html">Sale</a></div>
          <div><h5>Outerwear</h5><a href="shoes.html">All Outerwear</a><a href="running.html">For Producers</a><a href="lifestyle.html">Stage &amp; Tour</a></div>
          <div><h5>Apparel</h5><a href="clothing.html">All Apparel</a><a href="accessories.html">Accessories</a></div>
        </div>
      </div>
      <a href="kids.html">Crew</a>
      <a href="sale.html" class="is-sale">Sale</a>
    </nav>
    <div class="nav__tools">
      <form class="search" action="search.html" method="get" role="search">
        <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" stroke-width="2"/><line x1="16.5" y1="16.5" x2="22" y2="22" stroke="currentColor" stroke-width="2"/></svg>
        <input type="search" name="q" placeholder="Search" aria-label="Search" />
      </form>
      <a href="wishlist.html" class="icon-btn" aria-label="Wishlist">&#9825;<span class="badge" id="wishCount">0</span></a>
      <button class="icon-btn" data-cart-open aria-label="Bag" style="border:none;background:transparent;cursor:pointer;font-size:1.25rem;">&#9094;<span class="badge" id="cartCount">0</span></button>
      <a href="account.html" class="icon-btn" aria-label="Account" style="font-size:1.2rem;">&#9737;</a>
    </div>
  </header>
  <div class="drawer-overlay" id="drawerOverlay" data-cart-close></div>
  <aside class="cart-drawer" id="cartDrawer" aria-label="Shopping bag">
    <div class="cart-drawer__head"><h3>Your Bag</h3><button class="cart-drawer__close" data-cart-close aria-label="Close">&times;</button></div>
    <div class="cart-drawer__items" id="cartDrawerItems"></div>
    <div class="cart-drawer__foot">
      <div class="row"><span>Subtotal</span><span id="drawerSubtotal">€0.00</span></div>
      <a href="cart.html" class="btn btn--block">View Bag &amp; Checkout</a>
    </div>
  </aside>
NAVEOF

# ---------------- Canonical FOOTER ----------------
read -r -d '' FOOTER <<'FOOTEREOF' || true
  <footer class="footer">
    <div class="footer__top">
      <div class="footer__brand">
        <a href="index.html" class="footer__logo" aria-label="SILENCE home">
          <img src="logo-lockup-light.svg" alt="SILENCE" />
        </a>
        <p class="footer__tagline">For the people who make the sound. Apparel and wisdom for musicians — otherwise, I hear.</p>
        <div class="footer__social">
          <a href="https://www.instagram.com" target="_blank" rel="noopener noreferrer" aria-label="Instagram"><svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="4" stroke="currentColor" stroke-width="2"/><circle cx="17.5" cy="6.5" r="1.3" fill="currentColor"/></svg></a>
          <a href="https://www.tiktok.com" target="_blank" rel="noopener noreferrer" aria-label="TikTok"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M16 3c.3 2.1 1.5 3.6 3.6 3.9v2.4c-1.3.1-2.5-.3-3.6-1v5.9c0 3-2.1 5.3-5 5.3a5 5 0 0 1-5-5c0-2.9 2.3-5 5.2-4.9v2.5c-.3-.1-.6-.1-.9-.1a2.5 2.5 0 0 0 0 5c1.4 0 2.4-1.1 2.4-2.6V3H16Z"/></svg></a>
          <a href="https://x.com" target="_blank" rel="noopener noreferrer" aria-label="X"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M18.9 2H22l-7.6 8.7L23 22h-6.2l-4.9-6.4L6 22H2.9l8.1-9.3L2 2h6.4l4.4 5.8L18.9 2Z"/></svg></a>
          <a href="https://www.youtube.com" target="_blank" rel="noopener noreferrer" aria-label="YouTube"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M23 12s0-3.2-.4-4.7a2.5 2.5 0 0 0-1.8-1.8C19.3 5 12 5 12 5s-7.3 0-8.8.5A2.5 2.5 0 0 0 1.4 7.3C1 8.8 1 12 1 12s0 3.2.4 4.7a2.5 2.5 0 0 0 1.8 1.8C4.7 19 12 19 12 19s7.3 0 8.8-.5a2.5 2.5 0 0 0 1.8-1.8C23 15.2 23 12 23 12Zm-13 3V9l5 3-5 3Z"/></svg></a>
          <a href="https://www.facebook.com" target="_blank" rel="noopener noreferrer" aria-label="Facebook"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M14 9V7c0-1 .2-1.5 1.5-1.5H17V2.2C16.6 2.1 15.3 2 14.2 2 11.5 2 10 3.6 10 6.4V9H7.5v3H10v10h3.5V12H16l.5-3H14Z"/></svg></a>
        </div>
      </div>
      <form class="footer__news js-form" data-success="You're on the list. Check your inbox for €10 off. ✔">
        <h4>Join The List</h4>
        <p>Early access to drops, member exclusives and €10 off your first order.</p>
        <div class="footer__news-row">
          <input type="email" name="email" placeholder="Email address" required aria-label="Email address" />
          <button type="submit" class="btn">Sign Up</button>
        </div>
        <p class="form-note" role="status"></p>
      </form>
    </div>

    <div class="footer__cols">
      <div><h4>Shop</h4><a href="men.html">Men</a><a href="women.html">Women</a><a href="kids.html">Crew</a><a href="new-releases.html">New Drops</a><a href="best-sellers.html">Best Sellers</a><a href="sale.html">Sale</a></div>
      <div><h4>Collections</h4><a href="shoes.html">Outerwear</a><a href="clothing.html">Apparel</a><a href="accessories.html">Accessories</a><a href="running.html">For Producers</a><a href="training.html">For Artists</a><a href="lifestyle.html">Stage &amp; Tour</a><a href="run.html">Running</a><a href="gym.html">Gym &amp; Training</a></div>
      <div><h4>Help</h4><a href="faq.html">Help &amp; FAQ</a><a href="shipping.html">Shipping</a><a href="returns.html">Returns</a><a href="order-status.html">Track Order</a><a href="size-guide.html">Size Guide</a><a href="contact.html">Contact</a></div>
      <div><h4>Account</h4><a href="account.html">My Account</a><a href="order-history.html">Orders</a><a href="wishlist.html">Wishlist</a><a href="membership.html">Membership</a><a href="gift-cards.html">Gift Cards</a></div>
      <div><h4>Company</h4><a href="about.html">About</a><a href="sustainability.html">Sustainability</a><a href="careers.html">Careers</a><a href="press.html">Press</a><a href="journal.html">Journal</a><a href="store-locator.html">Stores</a></div>
    </div>

    <div class="footer__bar">
      <div class="footer__bar-left">
        <span class="footer__region">&#127757; Europe (EUR €) &middot; English</span>
        <span>&copy; 2026 SILENCE, Inc. All rights reserved.</span>
      </div>
      <nav class="footer__legal"><a href="terms.html">Terms</a><a href="privacy.html">Privacy</a><a href="cookies.html">Cookies</a><a href="contact.html">Accessibility</a></nav>
      <div class="footer__pay" aria-label="Accepted payment methods">
        <span class="footer__pay-label"><svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4" y="10.5" width="16" height="10.5" rx="2" fill="currentColor"/><path d="M7.5 10.5V7.5a4.5 4.5 0 0 1 9 0v3" stroke="currentColor" stroke-width="2"/></svg>Secure payments</span>
        <span class="pay-badge"><img src="pay-orange.svg" alt="Orange Money" loading="lazy" /></span><span class="pay-badge"><img src="pay-mtn.svg" alt="MTN MoMo" loading="lazy" /></span><span class="pay-badge"><img src="pay-wave.svg" alt="Wave" loading="lazy" /></span><span class="pay-badge"><img src="pay-djamo.svg" alt="Djamo" loading="lazy" /></span><span class="pay-badge"><img src="pay-push.svg" alt="Push" loading="lazy" /></span><span class="pay-badge pay-badge--text" title="Visa">VISA</span>
      </div>
    </div>
  </footer>
  <script src="script.js"></script>
</body>
</html>
FOOTEREOF

# ---------------- Product master list ----------------
IDS=(studio-jacket pleated-trouser wool-overshirt studio-hoodie tour-tee bside-crew producer-cap canvas-tote run-tee gym-shorts track-pant flex-hoodie)
NAMES=("SILENCE Studio Jacket" "SILENCE Pleated Trouser" "SILENCE Wool Overshirt" "SILENCE Studio Hoodie" "SILENCE Tour Tee" "SILENCE B-Side Crewneck" "SILENCE Producer Cap" "SILENCE Canvas Tote" "SILENCE Run Tee" "SILENCE Gym Shorts" "SILENCE Track Pant" "SILENCE Flex Hoodie")
LABELS=("Outerwear" "Trousers" "Overshirt" "Heavyweight Hoodie" "Tour T-Shirt" "Crewneck Sweat" "6-Panel Cap" "Tote Bag" "Running Top" "Training Shorts" "Track Trousers" "Training Hoodie")
PRICES=(189.99 129.99 159.99 119.99 44.99 89.99 34.99 29.99 49.99 44.99 79.99 99.99)
SALES=("" "" "" "" 31.49 "" "" "" "" "" "" "")
COLORS=(char black sky mint rose grey volt black sky char black mint)
CCAT=(clothing clothing clothing clothing clothing clothing accessories accessories active active active active)
CGEN=(unisex women men unisex men unisex unisex unisex unisex men unisex unisex)
PDP=(product-air-max-pulse product-pegasus-41 product-invincible-3 product-tech-fleece-hoodie product-pro-dri-fit-tee product-sportswear-joggers product-air-max-pulse product-pro-dri-fit-tee product-run-tee product-gym-shorts product-track-pant product-flex-hoodie)
BADGE=("New Drop" "New Drop" "New Drop" "" "Sale" "" "" "" "Active" "Active" "Active" "Active")

pcard(){
  local i=$1 id=${IDS[$i]} name=${NAMES[$i]} label=${LABELS[$i]} price=${PRICES[$i]} sale=${SALES[$i]}
  local color=${COLORS[$i]} ccat=${CCAT[$i]} cgen=${CGEN[$i]} pdp=${PDP[$i]} badge=${BADGE[$i]}
  local dprice=$price priceHtml="€$price" tag=""
  if [ -n "$sale" ]; then dprice=$sale; priceHtml="<s>€$price</s> €$sale"; fi
  if [ "$badge" = "Sale" ]; then tag='<span class="tag tag--sale">Sale</span>'; elif [ -n "$badge" ]; then tag="<span class=\"tag\">$badge</span>"; fi
  cat <<CARD
      <article class="product" data-name="$name" data-price="$dprice" data-cat="$ccat" data-gender="$cgen">
        <a href="$pdp.html" class="product__media" style="background:$(swatchcss "$color")">$tag</a>
        <h3><a href="$pdp.html">$name</a></h3>
        <p class="product__cat">$label</p>
        <p class="product__price">$priceHtml</p>
        <div class="product__actions">
          <button class="btn btn--sm" data-add-to-cart data-id="$id" data-name="$name" data-price="$dprice" data-img="$color">Add to Bag</button>
          <button class="wish" data-wish data-id="$id" data-name="$name" data-price="$dprice" data-img="$color" data-href="$pdp.html" aria-label="Add to wishlist">&#9825;</button>
        </div>
      </article>
CARD
}
all_cards(){ local n=${#IDS[@]}; for ((i=0;i<n;i++)); do pcard "$i"; done; }
active_cards(){ for i in 8 9 10 11; do pcard "$i"; done; }
related_section(){
  echo '  <section class="page-body" style="border-top:1px solid var(--line)">'
  echo '    <h2 style="margin-bottom:1.2rem">You might also like</h2>'
  echo '    <div class="product-grid">'
  for i in 0 2 5 7; do pcard "$i"; done
  echo '    </div>'
  echo '  </section>'
}

# ---------------- Fragment generators ----------------
hero(){ printf '  <section class="page-hero">\n    <p class="page-hero__kicker">%s</p>\n    <h1>%s</h1>\n    <p>%s</p>\n  </section>\n  <nav class="breadcrumb"><a href="index.html">Home</a><span>/</span>%s</nav>\n' "$2" "$1" "$3" "$1"; }

shoplisting(){ # title kicker sub
  local f="$CT/$4.html"
  { hero "$1" "$2" "$3"
    cat <<'SH'
  <section class="shop">
    <aside class="filters">
      <h4>Category</h4>
      <label><input type="checkbox" data-filter="cat" value="clothing"/> Apparel</label>
      <label><input type="checkbox" data-filter="cat" value="active"/> Activewear</label>
      <label><input type="checkbox" data-filter="cat" value="accessories"/> Accessories</label>
      <h4>Fit</h4>
      <label><input type="checkbox" data-filter="gender" value="men"/> Men</label>
      <label><input type="checkbox" data-filter="gender" value="women"/> Women</label>
      <label><input type="checkbox" data-filter="gender" value="unisex"/> Unisex</label>
    </aside>
    <div class="shop__main" id="shopMain">
      <div class="shop__bar">
        <span class="shop__count" id="shopCount"></span>
        <label class="sort">Sort by
          <select id="sortSelect">
            <option value="featured">Featured</option>
            <option value="low">Price: Low–High</option>
            <option value="high">Price: High–Low</option>
            <option value="name">Name A–Z</option>
          </select>
        </label>
      </div>
      <div class="product-grid">
SH
    all_cards
    cat <<'SH'
      </div>
    </div>
  </section>
SH
  } > "$f"
}

info(){ # slug title kicker sub body
  { hero "$2" "$3" "$4"; printf '  <section class="page-body">\n    <div class="prose">\n%s\n    </div>\n  </section>\n' "$5"; } > "$CT/$1.html"
}

# ---------------- Existing listing pages (now advanced) ----------------
shoplisting "Signature"    "The Originals"    "The pieces that define SILENCE — made for the people who make sound."       air-max
shoplisting "New Drops"    "Wisdom Begin"     "The latest gear, apparel and accessories. New pieces added regularly."      new-releases
shoplisting "Best Sellers" "Most Loved"       "What the community is reaching for right now."                              best-sellers
shoplisting "Sale"         "Up to 40% Off"    "Last chance markdowns. While stock lasts — no restocks."                   sale
shoplisting "Men"          "Shop Men"         "Studio-to-stage apparel, cut for him."                                     men
shoplisting "Women"        "Shop Women"       "Studio-to-stage apparel, cut for her."                                     women
shoplisting "Crew"         "For The Band"     "Everyday staples for the whole crew."                                      kids
shoplisting "Accessories"  "Finishing Touches" "Caps, straps, totes and the details that travel with you."               accessories
# ---------------- New collection pages ----------------
shoplisting "Outerwear"    "Layer Up"         "Jackets, overshirts and layers for studio, stage and street."               shoes
shoplisting "Apparel"      "Wear It"          "Heavyweight hoodies, tees and crewnecks for studio and stage."             clothing
shoplisting "For Producers" "In The Box"      "Tools and threads for the ones behind the board."                          running
shoplisting "For Artists"  "On The Mic"       "Built for writers, singers and players."                                   training
shoplisting "Stage & Tour" "On The Road"      "Hard-wearing pieces for life on tour."                                     lifestyle
shoplisting "DJs"          "Behind The Decks" "Gear and apparel for the selectors."                                       football
shoplisting "Vinyl & Merch" "Press Play"      "Records, totes and collectables from the SILENCE world."                  basketball

# ---------------- Sport collection (Running & Gym) ----------------
sportlisting(){ # title kicker sub slug
  { hero "$1" "$2" "$3"
    echo '  <section class="page-body">'
    echo '    <div class="product-grid">'
    active_cards
    echo '    </div>'
    echo '  </section>'
  } > "$CT/$4.html"
}
sportlisting "Running"        "Sport — Run"    "Lightweight, sweat-wicking performance pieces for every mile."             run
sportlisting "Gym &amp; Training" "Sport — Train"  "Four-way-stretch kit built for the gym floor — lift, train, recover."      gym

# ---------------- Existing info pages ----------------
info order-status "Order Status" "Track Your Order" "Enter your order number and email to see where your gear is." '      <p>Have your order number handy? Track your delivery in real time below. You can also find tracking links in your confirmation email.</p>
      <form class="app-form js-form" data-success="Found it! Your order is out for delivery and arrives soon. ✔">
        <label>Order number<input type="text" name="order" placeholder="ELAN-000000" required /></label>
        <label>Email address<input type="email" name="email" placeholder="you@email.com" required /></label>
        <button type="submit" class="btn">Track Order</button>
        <p class="form-note" role="status"></p>
      </form>'

info shipping "Shipping" "Delivery" "Fast, tracked delivery across Europe — free over €75." '      <h2>Delivery options</h2>
      <ul><li><strong>Standard</strong> — 2–4 working days. Free over €75, otherwise €4.95.</li>
      <li><strong>Express</strong> — next working day if ordered before 14:00. €9.95.</li>
      <li><strong>Click &amp; Collect</strong> — free pickup at any SILENCE store within 1–2 days.</li></ul>
      <h2>Tracking</h2><p>Every order ships with end-to-end tracking. Check anytime via <a href="order-status.html">Order Status</a>.</p>
      <h2>Where we ship</h2><p>We ship to all EU states, the UK, Norway and Switzerland. Duties and taxes are included at checkout.</p>'

info returns "Returns" "Returns &amp; Exchanges" "Changed your mind? You have 30 days, on us." '      <h2>30-day returns</h2><p>Return any unworn item within 30 days for a full refund. Members get 60 days.</p>
      <h2>How to return</h2><ul><li>Start your return via <a href="order-status.html">Order Status</a> or your account.</li>
      <li>Print the prepaid label and drop the parcel at any partner point.</li>
      <li>Refunds land within 5–7 working days of us receiving the item.</li></ul>
      <h2>Exchanges</h2><p>Need a different size? Select <em>Exchange</em> and we ship the replacement as soon as the original is on its way back.</p>'

info contact "Contact" "We are here to help" "Questions about an order, product or anything else? Reach out." '      <p>Our team is available Monday to Friday, 09:00–18:00 CET. We typically reply within one working day.</p>
      <ul><li><strong>Email</strong> — support@elan.example</li><li><strong>Phone</strong> — +33 1 23 45 67 89</li><li><strong>Live chat</strong> — during business hours</li></ul>
      <h2>Send us a message</h2>
      <form class="app-form js-form" data-success="Thanks for reaching out — we will reply within one working day. ✔">
        <label>Name<input type="text" name="name" required /></label>
        <label>Email<input type="email" name="email" required /></label>
        <label>Message<textarea name="message" rows="5" required></textarea></label>
        <button type="submit" class="btn">Send Message</button>
        <p class="form-note" role="status"></p>
      </form>'

# about / careers / sustainability / press are authored as rich animated fragments
# by the silence-company-pages workflow (kept in _content; not regenerated here).

info terms "Terms of Service" "Legal" "The terms that govern your use of SILENCE." '      <p>By accessing this website and placing an order, you agree to the following terms.</p>
      <h2>Use of the site</h2><p>You may use this site for lawful purposes only. All content and designs are the property of SILENCE, Inc.</p>
      <h2>Orders &amp; pricing</h2><p>All orders are subject to availability and confirmation. Prices include applicable taxes unless stated.</p>
      <h2>Liability</h2><p>To the extent permitted by law, SILENCE is not liable for indirect loss arising from use of this site.</p>
      <p><em>Last updated: June 2026. Sample copy for demonstration.</em></p>'

info privacy "Privacy Policy" "Legal" "How we collect, use and protect your data." '      <p>Your privacy matters to us. This policy explains what data we collect and how we use it.</p>
      <h2>What we collect</h2><p>Information you provide (name, email, address) and data gathered automatically (device, usage) to fulfil orders and improve our service.</p>
      <h2>How we use it</h2><ul><li>To process and deliver your orders.</li><li>To provide support.</li><li>To send updates where you have opted in.</li></ul>
      <h2>Your rights</h2><p>You may access, correct or delete your data anytime via the <a href="contact.html">contact page</a>.</p>
      <p><em>Last updated: June 2026. Sample copy for demonstration.</em></p>'

info cookies "Cookie Policy" "Legal" "How and why we use cookies on this site." '      <p>We use cookies to make this site work and to understand how it is used.</p>
      <h2>Types of cookies</h2><ul><li><strong>Essential</strong> — required for the site and checkout.</li><li><strong>Analytics</strong> — help us improve.</li><li><strong>Marketing</strong> — relevant offers, with consent.</li></ul>
      <h2>Managing cookies</h2><p>Control or delete cookies in your browser settings anytime.</p>
      <p><em>Last updated: June 2026. Sample copy for demonstration.</em></p>'

# ---------------- New structural pages ----------------
# Cart
{ hero "Your Bag" "Checkout" "Review your items and check out securely."
  cat <<'EOF'
  <section class="page-body">
    <div id="cartPage" class="two-col">
      <div id="cartItems"></div>
      <aside id="cartSummary" class="cart-summary sticky-side"></aside>
    </div>
  </section>
EOF
} > "$CT/cart.html"

# Wishlist
{ hero "Wishlist" "Saved" "Everything you love, in one place."
  printf '  <section class="page-body"><div id="wishPage"></div></section>\n'; } > "$CT/wishlist.html"

# Search
{ hero "Search" "Find It" "Search the full SILENCE catalogue."
  cat <<'EOF'
  <section class="page-body">
    <div class="locator-search"><input type="search" id="searchInput" placeholder="Search products…" aria-label="Search products" autofocus /></div>
    <h2 id="searchHeading" style="margin:1.4rem 0 1rem">All products</h2>
    <div class="product-grid" id="searchGrid">
EOF
  all_cards
  printf '    </div>\n    <p id="searchEmpty" class="cart-empty" style="display:none">No products match your search. Try another term.</p>\n  </section>\n'
} > "$CT/search.html"

# Gift cards
{ hero "Gift Cards" "Always the Right Fit" "The perfect gift — delivered instantly by email."
  cat <<'EOF'
  <section class="page-body"><div class="two-col">
    <div class="product__media" style="background:linear-gradient(150deg,#f6e1d6,#edc4b3);aspect-ratio:16/10;border-radius:12px;display:flex;align-items:center;justify-content:center;font-family:var(--display);font-size:2rem;color:#111">SILENCE GIFT CARD</div>
    <div>
      <h2>Digital Gift Card</h2>
      <p class="lead">Choose an amount and we will email a personalised gift card with a unique code. Redeemable online and in store, no expiry.</p>
      <div class="chips">
        <button class="chip" data-value="25">€25</button>
        <button class="chip active" data-value="50">€50</button>
        <button class="chip" data-value="100">€100</button>
        <button class="chip" data-value="150">€150</button>
        <button class="chip" data-value="250">€250</button>
      </div>
      <button class="btn" data-add-to-cart data-id="gift-card" data-name="SILENCE Gift Card €50.00" data-price="50" data-img="volt">Add to Bag</button>
    </div>
  </div></section>
EOF
} > "$CT/gift-cards.html"

# Account dashboard
{ hero "My Account" "Dashboard" "Manage your orders, details and preferences."
  cat <<'EOF'
  <section class="page-body">
    <div class="account-grid">
      <a class="acct-card" href="order-history.html"><h3>Orders</h3><p>Track, return or buy again.</p></a>
      <a class="acct-card" href="wishlist.html"><h3>Wishlist</h3><p>Your saved items.</p></a>
      <a class="acct-card" href="membership.html"><h3>Membership</h3><p>Your perks &amp; benefits.</p></a>
      <a class="acct-card" href="order-status.html"><h3>Track Order</h3><p>Where is my delivery?</p></a>
      <a class="acct-card" href="size-guide.html"><h3>Sizes</h3><p>Your saved sizes &amp; guide.</p></a>
      <a class="acct-card" href="login.html"><h3>Sign Out</h3><p>End your session.</p></a>
    </div>
  </section>
EOF
} > "$CT/account.html"

# Login
{ hero "Sign In" "Welcome Back" "Sign in to your SILENCE account."
  cat <<'EOF'
  <section class="page-body"><div class="auth">
    <form class="app-form js-form" data-success="Signed in — welcome back! ✔">
      <label>Email<input type="email" name="email" required /></label>
      <label>Password<input type="password" name="password" required /></label>
      <button type="submit" class="btn btn--block">Sign In</button>
      <p class="form-note" role="status"></p>
    </form>
    <p class="auth__alt">New here? <a href="register.html">Create an account →</a></p>
  </div></section>
EOF
} > "$CT/login.html"

# Register
{ hero "Join Us" "Become a Member" "Create your free SILENCE account and get €10 off your first order."
  cat <<'EOF'
  <section class="page-body"><div class="auth">
    <form class="app-form js-form" data-success="Welcome to SILENCE! Check your inbox for €10 off. ✔">
      <label>First name<input type="text" name="first" required /></label>
      <label>Email<input type="email" name="email" required /></label>
      <label>Password<input type="password" name="password" required /></label>
      <button type="submit" class="btn btn--block">Create Account</button>
      <p class="form-note" role="status"></p>
    </form>
    <p class="auth__alt">Already a member? <a href="login.html">Sign in →</a></p>
  </div></section>
EOF
} > "$CT/register.html"

# Order history
{ hero "Order History" "Your Orders" "A record of everything you have ordered."
  cat <<'EOF'
  <section class="page-body"><div class="table-wrap"><table class="tbl">
    <thead><tr><th>Order</th><th>Date</th><th>Items</th><th>Total</th><th>Status</th></tr></thead>
    <tbody>
      <tr><td>ELAN-104832</td><td>12 Jun 2026</td><td>Air Max Pulse</td><td>€159.99</td><td><span style="color:#157f3b;font-weight:600">Delivered</span></td></tr>
      <tr><td>ELAN-104511</td><td>03 Jun 2026</td><td>Tech Fleece Hoodie, Club Cap</td><td>€134.98</td><td><span style="color:#157f3b;font-weight:600">Delivered</span></td></tr>
      <tr><td>ELAN-103998</td><td>21 May 2026</td><td>Pegasus 41</td><td>€134.99</td><td>Out for delivery</td></tr>
      <tr><td>ELAN-103710</td><td>09 May 2026</td><td>Pro Dri-FIT Tee ×2</td><td>€62.98</td><td><span style="color:#157f3b;font-weight:600">Delivered</span></td></tr>
    </tbody>
  </table></div></section>
EOF
} > "$CT/order-history.html"

# Size guide
{ hero "Size Guide" "Find Your Fit" "Measurements and conversions for footwear and apparel."
  cat <<'EOF'
  <section class="page-body">
    <div class="toggle-unit"><button data-unit="cm" class="active">CM</button><button data-unit="in">IN</button></div>
    <h2>Footwear (Unisex)</h2>
    <div class="table-wrap"><table class="tbl">
      <thead><tr><th>UK</th><th>EU</th><th>US (M)</th><th>Foot length</th></tr></thead>
      <tbody>
        <tr><td>6</td><td>39.5</td><td>7</td><td><span data-cm>24.5 cm</span><span data-in style="display:none">9.6 in</span></td></tr>
        <tr><td>7</td><td>41</td><td>8</td><td><span data-cm>25.5 cm</span><span data-in style="display:none">10.0 in</span></td></tr>
        <tr><td>8</td><td>42.5</td><td>9</td><td><span data-cm>26.5 cm</span><span data-in style="display:none">10.4 in</span></td></tr>
        <tr><td>9</td><td>44</td><td>10</td><td><span data-cm>27.5 cm</span><span data-in style="display:none">10.8 in</span></td></tr>
        <tr><td>10</td><td>45</td><td>11</td><td><span data-cm>28.5 cm</span><span data-in style="display:none">11.2 in</span></td></tr>
        <tr><td>11</td><td>46</td><td>12</td><td><span data-cm>29.5 cm</span><span data-in style="display:none">11.6 in</span></td></tr>
      </tbody>
    </table></div>
    <h2 style="margin-top:2rem">Apparel (Tops)</h2>
    <div class="table-wrap"><table class="tbl">
      <thead><tr><th>Size</th><th>Chest</th><th>Waist</th></tr></thead>
      <tbody>
        <tr><td>XS</td><td><span data-cm>86 cm</span><span data-in style="display:none">34 in</span></td><td><span data-cm>71 cm</span><span data-in style="display:none">28 in</span></td></tr>
        <tr><td>S</td><td><span data-cm>94 cm</span><span data-in style="display:none">37 in</span></td><td><span data-cm>79 cm</span><span data-in style="display:none">31 in</span></td></tr>
        <tr><td>M</td><td><span data-cm>102 cm</span><span data-in style="display:none">40 in</span></td><td><span data-cm>87 cm</span><span data-in style="display:none">34 in</span></td></tr>
        <tr><td>L</td><td><span data-cm>110 cm</span><span data-in style="display:none">43 in</span></td><td><span data-cm>95 cm</span><span data-in style="display:none">37 in</span></td></tr>
        <tr><td>XL</td><td><span data-cm>118 cm</span><span data-in style="display:none">46 in</span></td><td><span data-cm>103 cm</span><span data-in style="display:none">41 in</span></td></tr>
      </tbody>
    </table></div>
    <p style="margin-top:1.4rem;color:var(--grey)">Between sizes? We recommend sizing up for a relaxed fit. Still unsure? <a href="contact.html" style="color:var(--ink)">Ask our team</a>.</p>
  </section>
EOF
} > "$CT/size-guide.html"

# Store locator
{ hero "Store Locator" "Visit Us" "Find your nearest SILENCE store across Europe."
  cat <<'EOF'
  <section class="page-body">
    <div class="locator-search"><input type="search" id="locatorInput" placeholder="Search by city or country…" aria-label="Search stores" /></div>
    <div class="stores">
      <div class="store"><h3>SILENCE Paris — Le Marais</h3><p>12 Rue de Bretagne, 75003 Paris, France</p><p class="open">Open until 20:00</p></div>
      <div class="store"><h3>SILENCE London — Soho</h3><p>45 Carnaby Street, London W1F, United Kingdom</p><p class="open">Open until 21:00</p></div>
      <div class="store"><h3>SILENCE Berlin — Mitte</h3><p>Friedrichstraße 76, 10117 Berlin, Germany</p><p class="open">Open until 20:00</p></div>
      <div class="store"><h3>SILENCE Amsterdam — Centrum</h3><p>Kalverstraat 92, 1012 Amsterdam, Netherlands</p><p class="open">Open until 19:00</p></div>
      <div class="store"><h3>SILENCE Milan — Duomo</h3><p>Corso Vittorio Emanuele II, 20122 Milan, Italy</p><p class="open">Open until 20:00</p></div>
      <div class="store"><h3>SILENCE Madrid — Salamanca</h3><p>Calle de Serrano 40, 28001 Madrid, Spain</p><p class="open">Open until 21:00</p></div>
      <div class="store"><h3>SILENCE Barcelona — Eixample</h3><p>Passeig de Gràcia 55, 08007 Barcelona, Spain</p><p class="open">Open until 21:00</p></div>
      <div class="store"><h3>SILENCE Copenhagen — Indre By</h3><p>Strøget 12, 1160 Copenhagen, Denmark</p><p class="open">Open until 19:00</p></div>
    </div>
  </section>
EOF
} > "$CT/store-locator.html"

# FAQ
{ hero "Help &amp; FAQ" "Support" "Answers to the questions we hear most."
  cat <<'EOF'
  <section class="page-body"><div class="accordion">
    <div class="acc-item open"><button class="acc-q">How long does delivery take?</button><div class="acc-a"><div><p>Standard delivery is 2–4 working days (free over €75), and express is next working day if you order before 14:00. Track anytime via <a href="order-status.html">Order Status</a>.</p></div></div></div>
    <div class="acc-item"><button class="acc-q">What is your returns policy?</button><div class="acc-a"><div><p>You have 30 days to return unworn items for a full refund — 60 days for members. See <a href="returns.html">Returns</a> for the full process.</p></div></div></div>
    <div class="acc-item"><button class="acc-q">How do I find my size?</button><div class="acc-a"><div><p>Use our <a href="size-guide.html">Size Guide</a> for footwear and apparel conversions. When in doubt, size up.</p></div></div></div>
    <div class="acc-item"><button class="acc-q">Do you offer gift cards?</button><div class="acc-a"><div><p>Yes — digital <a href="gift-cards.html">Gift Cards</a> are delivered instantly by email and never expire.</p></div></div></div>
    <div class="acc-item"><button class="acc-q">What are the benefits of membership?</button><div class="acc-a"><div><p>Members get free shipping, first access to drops, member pricing and extended returns. Learn more on <a href="membership.html">Membership</a>.</p></div></div></div>
    <div class="acc-item"><button class="acc-q">How do I contact support?</button><div class="acc-a"><div><p>Email support@elan.example or use our <a href="contact.html">contact form</a>. We reply within one working day.</p></div></div></div>
  </div></section>
EOF
} > "$CT/faq.html"

echo "Deterministic fragments written: $(ls "$CT" | wc -l)"

# ---------------- Full manifest (slug<TAB>title) ----------------
MANIFEST="air-max	Air Max
new-releases	New Releases
best-sellers	Best Sellers
sale	Sale
men	Men
women	Women
kids	Kids
accessories	Accessories
order-status	Order Status
shipping	Shipping
returns	Returns
contact	Contact
about	About
careers	Careers
sustainability	Sustainability
press	Press
terms	Terms of Service
privacy	Privacy Policy
cookies	Cookie Policy
shoes	Outerwear
clothing	Apparel
running	For Producers
training	For Artists
lifestyle	Stage & Tour
football	DJs
basketball	Vinyl & Merch
cart	Bag
wishlist	Wishlist
search	Search
size-guide	Size Guide
store-locator	Store Locator
gift-cards	Gift Cards
membership	Membership
faq	Help & FAQ
journal	Journal
journal-air-revolution	The Air Revolution
journal-marathon-guide	Your First Marathon
journal-move-to-zero	Move to Zero
lookbook	Lookbook
account	My Account
login	Sign In
register	Join Us
order-history	Order History
product-air-max-pulse	SILENCE Studio Jacket
product-pegasus-41	SILENCE Pleated Trouser
product-invincible-3	SILENCE Wool Overshirt
product-tech-fleece-hoodie	SILENCE Studio Hoodie
product-pro-dri-fit-tee	SILENCE Tour Tee
product-sportswear-joggers	SILENCE B-Side Crewneck
product-run-tee	SILENCE Run Tee
product-gym-shorts	SILENCE Gym Shorts
product-track-pant	SILENCE Track Pant
product-flex-hoodie	SILENCE Flex Hoodie
run	Running
gym	Gym & Training"

# ---------------- Assemble ----------------
count=0; missing=0
while IFS=$'\t' read -r slug title; do
  [ -z "$slug" ] && continue
  frag="$CT/$slug.html"
  if [ ! -f "$frag" ]; then
    missing=$((missing+1))
    echo "  !! MISSING fragment: $slug (placeholder written)"
    printf '  <section class="page-hero"><h1>%s</h1><p>Coming soon.</p></section>\n' "$title" > "$frag"
  fi
  {
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
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
  <a class="skip-link" href="#content">Skip to content</a>
  <div class="anbar" id="anbar"><span>&#10038; Free shipping over &euro;75 &middot; Join <a href="membership.html">The SILENCE Circle</a> for early access &amp; &euro;10 off &rarr;</span><button class="anbar__x" data-anbar-close aria-label="Dismiss">&times;</button></div>
EOF
    printf '%s\n' "$NAV"
    printf '  <main id="content">\n'
    cat "$frag"
    case "$slug" in product-*) related_section ;; esac
    printf '  </main>\n'
    printf '  <button class="to-top" id="toTop" aria-label="Back to top">&uarr;</button>\n'
    printf '%s\n' "$FOOTER"
  } > "$DIR/$slug.html"
  count=$((count+1))
done <<< "$MANIFEST"

echo "Assembled $count pages. Missing fragments: $missing"
