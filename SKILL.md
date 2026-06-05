---
name: bulk-site-builder
description: >
  A multi-agent skill for bulk-generating 100+ professional business websites in one run.
  Use this skill whenever the user wants to build multiple websites at once, generate websites
  for businesses in a location, create landing pages at scale, bulk-produce HTML/React sites
  for a category of companies, or says anything like "build sites for businesses", "generate
  websites for 50 restaurants", "create landing pages for all gyms in X city", or "bulk website
  generation". This skill orchestrates three agents: Agent 1 discovers and collects business info
  via search, Agent 2 builds a unique website per business, Agent 3 compiles all business info
  into a structured Excel (.xlsx) spreadsheet with columns like business name, owner/contact name,
  location, email, phone number, website, rating, and services. Always trigger this skill when scale
  (10+ sites) or location-based business discovery is involved.
---

# Bulk Site Builder

A three-agent pipeline that discovers businesses, builds a unique website for each one, and compiles all their info into a clean Excel spreadsheet — all delivered together in a single ZIP file.

---

## Overview

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

**Agents 2 and 3 run in parallel** after Agent 1 finishes — both consume `business_data.json` independently.

---

## Step 0 — Gather Runtime Inputs

Before doing anything, ask the user for:

| Input | Example |
|---|---|
| Business type | "restaurants", "dental clinics", "gyms" |
| Location | "Dhaka, Bangladesh" / "New York, USA" |
| Number of sites | 10 / 50 / 100+ |
| Site type | HTML landing page / Multi-page HTML / React |

If any are missing, ask for them. Once you have all four, proceed.

---

## Step 1 — Agent 1: Business Discovery

**Goal**: Collect structured info on N businesses of the given type in the given location.

### How to run Agent 1

Use `web_search` and `places_search` (if available) to discover businesses. For each business, gather:

```json
{
  "id": "biz_001",
  "name": "Business Name",
  "type": "restaurant",
  "location": "Dhaka, Bangladesh",
  "address": "123 Main St, Gulshan, Dhaka",
  "phone": "+880-1234-567890",
  "email": "info@businessname.com or null",
  "contact_person": "Owner or manager name if available, else null",
  "contact_title": "Owner / Manager / Director etc., else null",
  "website": "https://example.com or null",
  "rating": 4.5,
  "description": "Short paragraph about what this business does, its vibe, specialties",
  "services": ["Service A", "Service B", "Service C"],
  "tagline": "A short memorable tagline (inferred from context)",
  "color_hint": "warm/cool/neutral/vibrant — infer from business type",
  "founded": "year or null",
  "employees": "estimated size: solo / small (2-10) / medium (11-50) / large (50+) or null",
  "social_media": {
    "facebook": "url or null",
    "instagram": "url or null",
    "linkedin": "url or null"
  }
}
```

### Discovery strategy

1. Use `places_search` with queries like `"restaurants in Gulshan Dhaka"`, `"dental clinics Dhaka Bangladesh"` etc.
2. If places_search returns fewer results than needed, supplement with `web_search` queries like `"top 50 gyms in Dhaka Bangladesh list"`.
3. Keep collecting until you hit the target N (or a reasonable maximum — see limits below).
4. Deduplicate by name + address.
5. Fill missing fields with smart inferences (e.g. infer services from business type).

### Limits & handling

- **Target met**: proceed immediately to Agent 2.
- **Fewer results than requested**: inform user ("Found 67 of 100 requested — proceeding with 67"), then continue.
- **Cap at 150 per run** to keep build time reasonable. If user wants more, recommend running in batches.

### Output

Save results to `/tmp/business_data.json` as a JSON array.

Print a summary table to the user:
```
✅ Agent 1 complete — found 84 businesses
Business type: Restaurant | Location: Dhaka, BD
Preview:
  1. The Spice Garden — Gulshan
  2. Nando's Dhaka — Banani
  3. ...
Launching Agent 2 (site builder) and Agent 3 (Excel compiler) in parallel...
```

---

## Step 2 — Agent 2: Website Builder

**Goal**: Generate one complete, unique, production-grade website per business.

Read the full site-building guide in `references/site-builder.md` before starting.

### Key rules

- Every site **must look unique** — different color palette, typography, layout, and aesthetic per business. No two sites should look the same.
- Every site **must include** (at minimum): **Hero/Banner**, **Services**, **Footer**.
- Site type comes from user's runtime choice: HTML landing page, multi-page HTML, or React.
- Name each site folder: `{id}_{slug}/` e.g. `biz_001_spice_garden/`

### Build loop

```python
for business in business_data:
    design = generate_unique_design_direction(business)
    site = build_site(business, design, site_type)
    save_to /tmp/sites/{business.id}_{slug}/
```

For **HTML landing page**: single `index.html` with all CSS/JS inline.
For **multi-page HTML**: `index.html`, `services.html`, `contact.html` + shared `style.css`.
For **React**: single `App.jsx` + `index.html` shell.

### Progress reporting

Print progress every 10 sites:
```
🏗️  Building sites... [23/84] ██████░░░░░░░░ 27%
```

---

## Step 3 — Agent 3: Excel Compiler

**Goal**: Read `business_data.json` and produce a clean, well-formatted Excel spreadsheet (`businesses.xlsx`) with one row per business.

### Output file

Save to `/tmp/businesses.xlsx`

### Excel columns (in order)

| # | Column Header | Source field | Notes |
|---|---|---|---|
| A | # | row number | 1, 2, 3… |
| B | Business Name | `name` | |
| C | Contact Person | `contact_person` | "N/A" if null |
| D | Contact Title | `contact_title` | "N/A" if null |
| E | Business Type | `type` | |
| F | Location | `location` | |
| G | Full Address | `address` | |
| H | Phone Number | `phone` | "N/A" if null |
| I | Email Address | `email` | "N/A" if null |
| J | Website | `website` | hyperlink if available |
| K | Rating | `rating` | number, 1 decimal |
| L | Services | `services` | join with ", " |
| M | Founded | `founded` | "N/A" if null |
| N | Est. Employees | `employees` | "N/A" if null |
| O | Facebook | `social_media.facebook` | "N/A" if null |
| P | Instagram | `social_media.instagram` | "N/A" if null |
| Q | LinkedIn | `social_media.linkedin` | "N/A" if null |
| R | Description | `description` | wrap text |

### Formatting requirements

Use `openpyxl` to build the file with these styles:

```python
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "Businesses"
```

- **Header row (row 1)**:
  - Background: dark navy `#1B2A4A`
  - Font: white, bold, Arial 11pt
  - Height: 30px
  - Frozen (freeze pane at A2)

- **Data rows**:
  - Alternating row fill: white `#FFFFFF` and light grey `#F5F7FA`
  - Font: Arial 10pt, black
  - Row height: 22px
  - Description column (R): wrap text, row height auto

- **All cells**:
  - Thin border on all sides: `#D0D7E2`
  - Vertical alignment: center (except description: top)

- **Column widths** (approximate):
  - A (#): 5
  - B (Business Name): 28
  - C (Contact Person): 22
  - D (Contact Title): 18
  - E-F: 18
  - G (Address): 35
  - H (Phone): 18
  - I (Email): 28
  - J (Website): 30
  - K (Rating): 10
  - L (Services): 40
  - M-N: 14
  - O-Q (Social): 30
  - R (Description): 50

- **Sheet tab color**: `#1B2A4A`

- **Add a second sheet** called `Summary` with:
  - Total businesses found
  - Business type and location
  - Date generated
  - Count of businesses with email (vs. N/A)
  - Count of businesses with phone
  - Count of businesses with website
  - Average rating (if available)

### Website column — hyperlinks

```python
from openpyxl.styles import Font as XLFont

if business.get("website"):
    cell = ws.cell(row=r, column=10, value=business["website"])
    cell.hyperlink = business["website"]
    cell.font = XLFont(color="0563C1", underline="single", name="Arial", size=10)
```

### Completion message

```
📊 Agent 3 complete — businesses.xlsx generated
   Rows: 84 businesses
   Columns: 18 fields
   Saved: /tmp/businesses.xlsx
```

---

## Step 3 — Package & Deliver

Once all sites are built:

```bash
cd /tmp
zip -r all_sites.zip sites/
```

Then copy to output:
```bash
cp /tmp/all_sites.zip /mnt/user-data/outputs/all_sites.zip
```

Present the file to the user using `present_files`.

Also generate a **summary report** (`summary.html`) inside the ZIP:

```
📦 Bulk Site Builder — Summary Report
Generated: 84 websites
Business type: Restaurant | Location: Dhaka, BD
Site type: HTML Landing Page
─────────────────────────────────────
 #   Business Name          Folder
─────────────────────────────────────
 1   The Spice Garden       biz_001_spice_garden/
 2   Nando's Dhaka          biz_002_nandos_dhaka/
...
```

---

## Design Principles (Agent 2)

Read `references/site-builder.md` for the full design system. In summary:

- Pick a **distinct aesthetic** per business (luxury, playful, minimal, bold, earthy, futuristic…)
- Use **Google Fonts** CDN — pick a unique pairing per site
- Colors derived from business type + vibe (warm for food, clinical-clean for health, energetic for fitness)
- Sections: Hero (full-viewport, bold headline + CTA), Services (cards or grid), Footer (address, phone, copyright)
- Animations: subtle entrance animations via CSS (`@keyframes fadeInUp`)
- Mobile responsive via CSS Grid/Flexbox

---

## Error Handling

| Situation | Action |
|---|---|
| Business has very little info | Fill with smart defaults for that business type |
| Build fails for one business | Skip, log error, continue — report at end |
| ZIP creation fails | Save individual site folders and present them |
| Under 10 businesses found | Warn user and ask if they want to continue |

---

## Reference Files

- `references/site-builder.md` — Full HTML/CSS/React generation guide, design system, section templates
- `scripts/zip_sites.sh` — Shell script for packaging (optional helper)
