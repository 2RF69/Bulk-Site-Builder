# 🏗️ Bulk Site Builder — Claude Skill

> **A three-agent pipeline that discovers real businesses, builds a unique website for each one, and compiles all their contact info into a formatted Excel spreadsheet — all delivered in a single ZIP file.**

---

## ✨ What It Does

Give Claude a business type and a location. This skill spins up three coordinated agents that work together to:

1. **Discover** up to 150 real businesses using live search and Google Places data
2. **Build** a unique, production-grade HTML or React website for every single business — no two sites look the same
3. **Compile** all business info (name, contact, phone, email, rating, services, socials) into a polished Excel spreadsheet
4. **Deliver** everything bundled in one `all_sites.zip` — ready to use

---

## 🚀 Example Prompts

```
Build websites for 50 restaurants in Dhaka, Bangladesh
Generate landing pages for all dental clinics in New York
Create sites for 30 gyms in London — use React
Bulk-build HTML pages for law firms in Dubai
```

---

## 🗺️ Architecture

```
User Input
    │
    ▼
┌─────────────────────────────────┐
│  AGENT 1 — Business Discoverer  │
│  Searches location + type       │
│  Collects: name, address,       │
│  phone, email, services, etc.   │
└──────────┬──────────────────────┘
           │  business_data.json
           ├──────────────────────────────────┐
           ▼                                  ▼
┌──────────────────────┐        ┌─────────────────────────────┐
│  AGENT 2             │        │  AGENT 3                    │
│  Site Builder        │        │  Excel Compiler             │
│  Builds one unique   │        │  Reads business_data.json   │
│  site per business   │        │  Outputs businesses.xlsx    │
│  (HTML / React)      │        │  with all contact fields    │
└──────────┬───────────┘        └──────────────┬──────────────┘
           │                                   │
           └──────────────┬────────────────────┘
                          ▼
              all_sites.zip (sites/ + businesses.xlsx)
                          │
                          ▼
                        User
```

**Agents 2 and 3 run in parallel** — both consume the same `business_data.json` after Agent 1 finishes.

---

## 📋 Inputs

When triggered, Claude will ask you for:

| Input | Description | Example |
|---|---|---|
| **Business type** | What kind of businesses to target | `restaurants`, `dental clinics`, `gyms` |
| **Location** | City + country | `Dhaka, Bangladesh` / `New York, USA` |
| **Number of sites** | How many to generate (max 150/run) | `50` |
| **Site type** | Format for the websites | `HTML landing page`, `Multi-page HTML`, `React` |

---

## 📦 Output

You receive a ZIP file containing:

```
all_sites.zip
├── sites/
│   ├── biz_001_spice_garden/
│   │   └── index.html
│   ├── biz_002_nandos_dhaka/
│   │   └── index.html
│   ├── biz_003_pizza_nation/
│   │   ├── index.html
│   │   ├── services.html
│   │   ├── contact.html
│   │   └── style.css        ← multi-page only
│   └── summary.html         ← full site index
└── businesses.xlsx          ← structured contact data
```

### Excel Spreadsheet (`businesses.xlsx`)

18-column spreadsheet with:

| Column | Field |
|---|---|
| A | # (row number) |
| B | Business Name |
| C | Contact Person |
| D | Contact Title |
| E | Business Type |
| F | Location |
| G | Full Address |
| H | Phone Number |
| I | Email Address |
| J | Website (hyperlinked) |
| K | Rating |
| L | Services |
| M | Founded |
| N | Est. Employees |
| O | Facebook |
| P | Instagram |
| Q | LinkedIn |
| R | Description |

Includes a **Summary sheet** with totals, coverage stats, and average rating.

---

## 🎨 Design System (Agent 2)

Every website gets its own unique design direction — no two sites share the same palette, typography, or layout aesthetic.

### 10 Aesthetic Archetypes

| Archetype | Best For | Vibe |
|---|---|---|
| **Luxury Editorial** | Fine dining, premium services | Deep navy + gold, serif display |
| **Bold Brutalist** | Gyms, streetwear, tech | Black + neon, heavy condensed sans |
| **Organic Warmth** | Cafes, bakeries, wellness | Terracotta + cream, rounded humanist |
| **Clinical Clean** | Dental, medical, pharmacy | White + teal, geometric sans |
| **Vibrant Playful** | Kids, events, fast food | Multi-color, rounded bouncy type |
| **Minimal Zen** | Spas, yoga, luxury retail | Off-white + muted sage, thin serif |
| **Industrial Raw** | Auto, hardware, construction | Dark grey + orange, monospace |
| **Retro Warm** | Barbershops, diners, vintage | Brown + mustard, slab serif |
| **Modern Tech** | SaaS, coworking, consultancy | Dark + electric blue, geometric |
| **Coastal Fresh** | Seafood, resorts, travel | Sky blue + white + sand |

### Every Site Includes

- ✅ Full-viewport **Hero** with business name, tagline, and CTA button
- ✅ **Services** section (grid/cards, 3+ services)
- ✅ **Footer** with address, phone, copyright
- ✅ Unique **Google Font** pairing
- ✅ CSS entrance **animations** (`fadeInUp`)
- ✅ Fully **mobile responsive** (CSS Grid/Flexbox)
- ✅ Business name in `<title>` tag
- ✅ No unfilled template placeholders

---

## 📁 File Structure

```
bulk-site-builder/
├── SKILL.md                          ← Skill manifest & full agent instructions
├── README.md                         ← This file
├── references/
│   └── site-builder.md               ← Design system, templates, palettes, defaults
└── scripts/
    └── zip_sites.sh                  ← Shell script to package output ZIP
```

---

## ⚙️ `scripts/zip_sites.sh`

A helper script that packages all built sites into a downloadable ZIP.

```bash
# Usage
bash scripts/zip_sites.sh [output_name]

# Example
bash scripts/zip_sites.sh my_restaurant_sites
# → Creates: /mnt/user-data/outputs/my_restaurant_sites.zip
```

If no name is given, defaults to `all_sites.zip`.

---

## 🧠 Smart Defaults

When business data is missing, the skill fills in sensible defaults by business type:

| Business Type | Default Services | Default Tagline |
|---|---|---|
| Restaurant | Dine-In, Takeaway, Catering | "A Taste Worth Remembering" |
| Dental Clinic | General Dentistry, Whitening, Ortho | "Your Smile, Our Priority" |
| Gym / Fitness | Personal Training, Classes, Nutrition | "Build the Body You Deserve" |
| Salon / Spa | Haircut, Massage, Facial, Manicure | "You Deserve to Feel Beautiful" |
| Law Firm | Consultation, Corporate, Family Law | "Justice You Can Trust" |
| Hotel | Accommodation, Conference, Restaurant | "Your Home Away From Home" |
| Pharmacy | Prescriptions, Consultations, Delivery | "Your Health, Always First" |
| Auto Repair | Oil Change, Engine Repair, Tires | "Keep Moving with Confidence" |
| Real Estate | Buy, Sell, Rent, Management | "Find Your Perfect Place" |
| School / Tutor | Coaching, Test Prep, Mentorship | "Empowering Futures" |

---

## 🔢 Limits & Batching

| Scenario | Behavior |
|---|---|
| Fewer results than requested | Informs user and continues with what was found |
| Over 150 businesses requested | Caps at 150 and recommends batching |
| Under 10 businesses found | Warns user and asks whether to continue |
| Build fails for one business | Skips it, logs error, continues — reports at end |
| ZIP creation fails | Saves individual folders and presents them instead |

---

## 🛠️ How to Install This Skill

1. Download or clone this repository
2. In Claude's skill directory, place the `bulk-site-builder/` folder at the appropriate path
3. The skill will auto-trigger when you describe bulk website generation tasks

### Trigger Phrases

This skill activates when you say things like:
- *"build sites for businesses"*
- *"generate websites for 50 restaurants"*
- *"create landing pages for all gyms in X city"*
- *"bulk website generation"*
- *"build multiple websites at once"*

---

## 📸 Example Output Preview

After a run, you'll see:

```
✅ Agent 1 complete — found 84 businesses
Business type: Restaurant | Location: Dhaka, BD

🏗️  Building sites... [84/84] ████████████████ 100%

📊 Agent 3 complete — businesses.xlsx generated
   Rows: 84 businesses | Columns: 18 fields

📦 Packaging ZIP...
✅ Done! all_sites.zip is ready to download.
```

---

## 📄 License

MIT — free to use, modify, and distribute.

---

## 🤝 Contributing

Pull requests welcome. To add a new aesthetic archetype or business type default, edit `references/site-builder.md` and update the relevant tables in `SKILL.md`.
