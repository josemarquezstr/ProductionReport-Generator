# Production Report Generator
TL;DR
---
Web application to fetch data from Supabase, generate interactive charts with Chart.js, and export reports to Excel. Built with Django, pandas, and tools for Excel import/export. This repository contains a minimal, team-friendly starter to run locally and collaborate via GitHub.

Status: Work in progress

Badges
---

Requirements
---
- Python 3.11.5(or newer 3.11.x)
- Windows / macOS / Linux (instructions emphasize PowerShell for Windows)
- See 'requeriments.txt' for exact Python packages and versions

Key dependencies
---
- `Django` — full featured framework used for routing, views, templates and admin.
- `supabase` (supabase-py) — client to quey Supabase (Postgres) as the primary data source.
- `pandas` — data manipulation and preparation for charts and Excel exports.
- `openpyxl` and `XlsxWriter` — Excel engines used by pandas for reading/writing `.xlsx` files.
- `django-import-export` — integrates with Django Admin to allow user-driven import/export (CSV, XLSX).
- `python-dotenv` — load local `.env` files without commiting secrets to the repo.

Quick start (Windows PowerShell)

---
1. Create and activate a virtual enviroment:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
```

2. INstall dependencies:

```powershell
pip install -r requeriments.txt
```

3. Copy example enviroment file and configure secrets:

```powershell
copy .env.example .env
#Edit .env and add SUPABASE_URL, SUPABASE_KEY, DJANGO_SECRET_KEY, DEBUG
```

Configuration
---
Create an `.env` file (do not comit it). The minimal variables required:

- `DJANGO_SECRET_KEY` — Django secret key.
- `DEBUG` — `True` or `False`.
- `SUPABASE_URL` — your Supabase project URL.
- `SUPABASE_KEY` — service role or anon key (prefer read-only key for the app).

Run locally
---
Apply migrations, create a superuser and start the server:

```powershell
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Open `http://127.0.0.1:8000/` for dashboard and `http://127.0.0.1:8000/admin/` for the admin panel.

API endpoints (examples)
---
- Chart data (JSON consumed by Chart.js):
    - `GET /api/data/?table=measurements&ts=ts&val=value`
    - Response: `{ "labels": [...], "values": [...] }`
- Export Excel (pandas -> openpyxl/XlsWriter):
    - `GET /export/excel/?table=measurements]` -> returns  `report.xlsx` download

Recommended project structure
---
- `production_report/` — Django project settings and URLs
- `reports/` — Django app with `models.py`, `views.py`, `services.py`, `supabase_client.py`, templates
- `requirements.txt` — pinned Python dependencies
- `.env.example` — example enviroment variables (safe to comit)
- `README.md` — this file

How the pieces fit (short)
---
- `supabase_client.py` encapsulates Supabase connection and queries (single point of change).
- `services.py` contains data transformation using `pandas` (agregation, resampling, cleaning).
- Chart.js runs in the browser and request JSON endpoints procuded by Django views.
- Excel export uses `pandas.DataFrame.to_excel()` with `openpyxl` or `XlsWriter` engines.
- `django-import-export` enables Admin users to import and export model data through the Django Admin UI.

Excel notes
---
- Use `openpyxl` as a default engine for compatibility when reading/writing `.xlsx` files.
- Use `XlsWriter` if you need advances formatting, formulas, or better performance when writting large files.
- For very large exports consider streaming or chucked generation to avoid high memory usage.

Security
---
- Never commit `.env` or any secret keys. Add `.env` to `.gitignore`.
- Use the latest-privilege Supabase key possible (read-only for reporting).
- Rotate keys if they are leaked.

Testing & CI
---
- Add test under each app with `pytest` or Django's `unittest` test runner.
- Example CI actions: install deps, run `python manage.py test`, run linters.

Collaboration & Git flow
---
- Use feature brances (`feat/`, `fix/`) and open Pull Request to `main`.
- Protect `main` with required reviews and passing CI.
- Add a `CONTRIBUTIN.MD` and `CODE_OD_CONDUCT.md` for community guidance.

Trobleshooting
---
- Connection refused to Supabase: verify `SUPABASE_URL` and `SUPABASE_KEY`, check network or firewall.
- Excel download returns corrupted files: ensure you use `BytesIO` and set the correct content-type and disposition.
- Chart shows no data: open the browser DevTools network tab to confirm the JSON response from `/api/data/`.

Further reading links
---
- Supabase docs: https://supabase.com/docs
- Django docs: https://docs.djangoproject.com/
- Chart.js: https://www.chartjs.org/docs/latest/
- pandas: https://pandas.pydata.org/docs/
- django-import-export: https://django-import-export.readthedocs.io/

Last updated: 2025-12-23