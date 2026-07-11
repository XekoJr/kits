# Kits

Kits is a full-stack web application for organizing packing/shopping lists ("kits"). Each kit is a named collection of items (with quantity and a purchased/checked state) that can be grouped into user-defined categories, making it easy to track what's needed and what's already been sorted out for a trip, event, or project.

## Features

- **Authentication** — register, login, and logout via token-based auth (Laravel Sanctum).
- **Kits** — create, view, update, and delete kits, each with a name and description.
- **Items** — add items to a kit, set a quantity, toggle a "purchased" state, and optionally assign a category.
- **Categories** — organize items into custom categories per user.
- **Internationalization** — UI available in English and Portuguese.

## Tech Stack

- **Backend**: [Laravel 12](https://laravel.com) (PHP 8.2) with [Sanctum](https://laravel.com/docs/sanctum) for API token authentication, running behind Apache in Docker.
- **Frontend**: [Svelte 4](https://svelte.dev) + [Vite](https://vitejs.dev), a single-page application that consumes the Laravel API.
- **Database**: PostgreSQL.

## Project Structure

```
kits-project/
├── backend/    # Laravel API (auth, kits, items, categories), own Dockerfile
├── frontend/   # Svelte SPA built with Vite, served by nginx, own Dockerfile
└── docker-compose.yml.example
```

## Getting Started

### Docker

Copy the example env and compose files and fill in the required values:

```bash
cp .env.example .env
cp docker-compose.yml.example docker-compose.yml
```

Then build and start the containers:

```bash
docker compose up -d --build
```

By default the frontend is available on `http://localhost:8080` (which reverse-proxies
`/api` requests to the backend), the backend API directly on `http://localhost:8000`,
and PostgreSQL on port `5432`. Ports and credentials are configured via `.env`.

### Backend (manual setup)

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
composer run dev
```

`composer run dev` starts the Laravel server, queue listener, log viewer, and Vite dev server concurrently.

### Frontend (manual setup)

```bash
cd frontend
npm install
npm run dev
```

## API Overview

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/register` | Register a new user |
| POST | `/api/login` | Log in and receive an API token |
| POST | `/api/logout` | Log out (requires auth) |
| GET | `/api/me` | Get the authenticated user |
| GET/POST/PUT/DELETE | `/api/kits` | CRUD for kits |
| GET/POST | `/api/kits/{kit_id}/items` | List/create items for a kit |
| PUT/DELETE | `/api/kits/{kit_id}/items/{id}` | Update/delete an item |
| PATCH | `/api/kits/{kit_id}/items/{id}/toggle` | Toggle an item's purchased state |
| GET/POST/PUT/DELETE | `/api/categories` | CRUD for categories |

All routes except register/login require a valid Sanctum token via the `Authorization: Bearer` header.
