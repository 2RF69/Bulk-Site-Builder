# Site Builder Reference Guide

This file is read by Agent 2 before generating any websites.

---

## Unique Design Per Business — How To

Every business gets a unique design direction. Before writing any code for a business, decide:

### 1. Aesthetic Archetype (pick one per business, rotate through these)

| Archetype | Best for | Color vibe | Font style |
|---|---|---|---|
| Luxury Editorial | Fine dining, premium services | Deep navy + gold | Serif display + light sans |
| Bold Brutalist | Gyms, streetwear, tech | Black + neon accent | Heavy condensed sans |
| Organic Warmth | Cafes, bakeries, wellness | Earthy terracotta + cream | Rounded humanist sans |
| Clinical Clean | Dental, medical, pharmacy | White + teal/blue | Geometric sans |
| Vibrant Playful | Kids, events, fast food | Multi-color, bright | Rounded + bouncy |
| Minimal Zen | Spas, yoga, luxury retail | Off-white + muted sage | Thin elegant serif |
| Industrial Raw | Auto repair, hardware, construction | Dark grey + orange | Monospace + bold |
| Retro Warm | Barbershops, diners, vintage shops | Brown + mustard | Slab serif + retro sans |
| Modern Tech | SaaS, coworking, consultancy | Dark + electric blue | Clean geometric |
| Coastal Fresh | Seafood, resorts, travel | Sky blue + white + sand | Casual humanist |

Cycle through these and also invent variations. **No two consecutive sites should share an aesthetic.**

---

## HTML Landing Page Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{BUSINESS_NAME}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family={DISPLAY_FONT}&family={BODY_FONT}&display=swap" rel="stylesheet">
  <style>
    /* CSS Variables — unique per site */
    :root {
      --primary: {COLOR_1};
      --accent: {COLOR_2};
      --bg: {BG_COLOR};
      --text: {TEXT_COLOR};
      --font-display: '{DISPLAY_FONT}', serif;
      --font-body: '{BODY_FONT}', sans-serif;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: var(--font-body); background: var(--bg); color: var(--text); }

    /* ── HERO ─────────────────────────────── */
    .hero {
      min-height: 100vh;
      background: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      text-align: center;
      padding: 2rem;
      position: relative;
      overflow: hidden;
    }
    .hero::before {
      /* decorative background shape — varies per aesthetic */
      content: '';
      position: absolute;
      /* customize per aesthetic */
    }
    .hero h1 {
      font-family: var(--font-display);
      font-size: clamp(2.5rem, 8vw, 6rem);
      color: var(--accent);
      animation: fadeInUp 0.8s ease both;
    }
    .hero p.tagline {
      font-size: clamp(1rem, 2.5vw, 1.4rem);
      margin: 1.5rem 0 2.5rem;
      opacity: 0.85;
      animation: fadeInUp 0.8s 0.2s ease both;
    }
    .hero .cta {
      background: var(--accent);
      color: var(--bg);
      padding: 1rem 2.5rem;
      border: none;
      font-size: 1.1rem;
      font-weight: 700;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      animation: fadeInUp 0.8s 0.4s ease both;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .hero .cta:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.2); }

    /* ── SERVICES ─────────────────────────── */
    .services {
      padding: 6rem 2rem;
      background: var(--bg);
    }
    .services h2 {
      font-family: var(--font-display);
      text-align: center;
      font-size: clamp(2rem, 5vw, 3.5rem);
      margin-bottom: 3rem;
      color: var(--primary);
    }
    .services-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 2rem;
      max-width: 1200px;
      margin: 0 auto;
    }
    .service-card {
      background: var(--primary);
      color: var(--accent);
      padding: 2.5rem 2rem;
      border-radius: {BORDER_RADIUS}; /* varies: 0px brutalist, 8px clean, 24px playful */
      transition: transform 0.3s, box-shadow 0.3s;
    }
    .service-card:hover { transform: translateY(-6px); box-shadow: 0 16px 40px rgba(0,0,0,0.15); }
    .service-card h3 { font-family: var(--font-display); font-size: 1.4rem; margin-bottom: 0.75rem; }
    .service-card p { opacity: 0.8; line-height: 1.6; }

    /* ── FOOTER ───────────────────────────── */
    footer {
      background: var(--primary);
      color: var(--accent);
      padding: 3rem 2rem;
      text-align: center;
    }
    footer .footer-name {
      font-family: var(--font-display);
      font-size: 1.8rem;
      margin-bottom: 0.5rem;
    }
    footer .footer-info { opacity: 0.75; line-height: 2; font-size: 0.95rem; }
    footer .footer-copy { margin-top: 2rem; font-size: 0.8rem; opacity: 0.5; }

    /* ── ANIMATIONS ───────────────────────── */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── RESPONSIVE ───────────────────────── */
    @media (max-width: 768px) {
      .services-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

  <!-- HERO -->
  <section class="hero">
    <h1>{BUSINESS_NAME}</h1>
    <p class="tagline">{TAGLINE}</p>
    <a href="#services" class="cta">Explore Our Services</a>
  </section>

  <!-- SERVICES -->
  <section class="services" id="services">
    <h2>What We Offer</h2>
    <div class="services-grid">
      {SERVICE_CARDS}
      <!-- Each card:
      <div class="service-card">
        <h3>Service Name</h3>
        <p>Short description of this service.</p>
      </div>
      -->
    </div>
  </section>

  <!-- FOOTER -->
  <footer>
    <div class="footer-name">{BUSINESS_NAME}</div>
    <div class="footer-info">
      📍 {ADDRESS}<br>
      📞 {PHONE}<br>
      {WEBSITE_LINE}
    </div>
    <div class="footer-copy">© {YEAR} {BUSINESS_NAME}. All rights reserved.</div>
  </footer>

</body>
</html>
```

---

## Multi-Page HTML Structure

```
{id}_{slug}/
├── index.html      ← same hero + services above + footer
├── services.html   ← expanded services with descriptions
├── contact.html    ← contact form + address + map embed (Google Maps embed via address)
└── style.css       ← shared stylesheet (extract all CSS here)
```

For `contact.html`, include:
- A simple contact form (name, email, message, submit button — no backend needed, just UI)
- Google Maps embed using the business address:
  `<iframe src="https://maps.google.com/maps?q={ENCODED_ADDRESS}&output=embed" ...>`
- Phone and address displayed prominently

---

## React Site Structure

```jsx
// App.jsx — single file
import { useState } from "react";

const businessData = {JSON_DATA_OBJECT};

export default function App() {
  return (
    <div style={styles.app}>
      <Hero />
      <Services />
      <Footer />
    </div>
  );
}

function Hero() { /* ... */ }
function Services() { /* ... */ }
function Footer() { /* ... */ }

const styles = { /* inline styles object */ };
```

Use inline styles (no Tailwind dependency), unique per business.

---

## Folder & File Naming

```
/tmp/sites/
├── biz_001_spice_garden/
│   └── index.html
├── biz_002_nandos_dhaka/
│   └── index.html
...
└── summary.html
```

Slug rules:
- Lowercase, spaces → underscores
- Remove special characters
- Max 30 chars
- Example: "The Spice Garden & Co." → `the_spice_garden_co`

---

## Smart Defaults by Business Type

When info is missing, use these defaults:

| Business Type | Default Services | Default Tagline |
|---|---|---|
| Restaurant | Dine-In, Takeaway, Catering | "A Taste Worth Remembering" |
| Dental Clinic | General Dentistry, Teeth Whitening, Orthodontics | "Your Smile, Our Priority" |
| Gym / Fitness | Personal Training, Group Classes, Nutrition Coaching | "Build the Body You Deserve" |
| Salon / Spa | Haircut, Massage, Facial, Manicure | "You Deserve to Feel Beautiful" |
| Law Firm | Consultation, Corporate Law, Family Law | "Justice You Can Trust" |
| Hotel | Accommodation, Conference Rooms, Restaurant | "Your Home Away From Home" |
| Pharmacy | Prescription Filling, Consultations, Delivery | "Your Health, Always First" |
| Auto Repair | Oil Change, Engine Repair, Tire Service | "Keep Moving with Confidence" |
| Real Estate | Buy, Sell, Rent, Property Management | "Find Your Perfect Place" |
| School / Tutor | Academic Coaching, Test Prep, Mentorship | "Empowering Futures, One Lesson at a Time" |

---

## Color Palettes by Business Type

Rotate through these, don't reuse the same palette consecutively:

```
Restaurants:
  - Deep burgundy #4A0E0E + cream #F5EDD6 + gold #C9A84C
  - Forest green #1B4332 + off-white #F8F5F0 + terracotta #C65D3B
  - Charcoal #2D2D2D + warm white #FFF8F0 + orange #FF6B35

Medical / Dental:
  - Navy #0B2545 + white + sky #5BC0EB
  - Slate #2C3E50 + mint #A8DADC + white
  - Deep teal #006D6E + white + light grey #F0F4F8

Fitness / Gym:
  - Black #0D0D0D + electric lime #B5FF2D + dark grey #1A1A1A
  - Midnight #1A1A2E + vivid orange #FF4500 + white
  - Dark navy #0A0A23 + cyan #00F5FF + white

Beauty / Wellness:
  - Blush pink #F7CAC9 + ivory #F6F0E4 + rose gold #B5764B
  - Sage #87A878 + warm beige #F2E8DC + terracotta
  - Lavender #7B6D8D + off-white + gold

Tech / Coworking:
  - Deep charcoal #111827 + electric blue #3B82F6 + white
  - Off-black #0F0F0F + acid green #39FF14 + grey
  - Slate #1E293B + violet #7C3AED + light grey
```

---

## Quality Checklist (per site)

Before saving each site, verify:
- [ ] Business name in title tag
- [ ] Hero has business name + tagline + CTA button
- [ ] At least 3 service cards (use defaults if needed)
- [ ] Footer has name, address, phone, and copyright year
- [ ] Font loaded from Google Fonts CDN
- [ ] Mobile responsive (uses CSS grid/flexbox, no fixed pixel widths)
- [ ] Unique color palette (not same as previous site)
- [ ] No template placeholder text visible (no `{VARIABLE}` left unfilled)
