# Bespoke Tailor Pro (ビスポーク・テーラー・プロ) 🧵

> **Architectural Status:** Development (Feature/integrate-money-rails) | **Ruby:** 4.0.0 | **Rails:** 8.1.3
> 
> *A high-precision ERP and measurement management system designed for elite bespoke tailoring houses. Focused on anatomical data integrity, financial scalability, and a "Shibui" (渋い) minimalist aesthetic.*

---

## 🏛 Architectural Philosophy (設計思想)

This project demonstrates **Shokunin (Artisan)** engineering applied to modern software development, focusing on high-quality code and a sophisticated, understated user experience.

### Core Engineering Features:
* **Financial Integrity (`money-rails`):** [IN PROGRESS] Precision-first monetary handling to prevent rounding errors, with native multi-currency support (BRL/JPY/USD).
* **Anatomical Data Engine (JSONB):** [PLANNED] PostgreSQL `jsonb` with GIN Indexing for storing multi-dimensional body metrics with high performance.
* **"Shibui" UI Framework (Hotwire & Tailwind):** [PLANNED] A minimalist design system focused on balance, subtle details, and quiet excellence (Shibui aesthetics).
* **Zero-Leak Performance:** `Strict Loading` enabled by default to eliminate N+1 query patterns at the architectural level.

---

## 🛠 Tech Stack (技術スタック)

* **Language:** Ruby 4.0.0
* **Framework:** Rails 8.1.3
* **Frontend:** Hotwire (Turbo & Stimulus) - *Pending Implementation*
* **Styling:** Tailwind CSS (Shibui Theme) - *Pending Implementation*
* **Database:** PostgreSQL 16+ (Optimized for JSONB)
* **Test Suite:** RSpec (Behavior-Driven Development)
* **Containerization:** Docker

---

## 🇯🇵 Japan-Ready Implementation (日本市場対応)

System built with internationalization (i18n) at its core, specifically optimized for the Japanese luxury market:
* **Localization:** Full support for Japanese (日本語) and English.
* **Measurement Standards:** Configurable units (Centimeters/Inches).
* **Aesthetics:** Adherence to "Shibui" principles — simplicity, modesty, and quiet excellence.

---

## 🚀 Quick Start (クイックスタート)

```bash
# Clone the repository
git clone [https://github.com/FragozoLeonardo/bespoke_tailor_pro.git](https://github.com/FragozoLeonardo/bespoke_tailor_pro.git)

# Setup the environment with Docker
docker compose build
docker compose up -d

# Initialize the database
docker compose exec web rails db:prepare