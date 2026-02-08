# React Vite Scaffolding (Extended)

A lightweight toolkit to bootstrap a **Vite + React + TypeScript** app and then apply a consistent **testing and tooling scaffold**.

This repository provides a two-step workflow to keep project creation simple and tooling setup reliable.

## Why

to quickly set-up the base requirements when scaffolding an app.

## Overview

This repo contains **two scripts**:

- **create-vite-react-ts.sh**  
  Creates the base Vite React + TypeScript project (interactive).

- **apply-scaffold.sh**  
  Adds unit testing, a minimal API boundary, and updates project scripts.

Keeping these steps separate avoids issues with interactive scaffolding and long-running processes.

## Requirements

- Node.js (recommended: v20+)
- npm

## Usage

### 1) Create a new Vite React + TypeScript project

From this repository root:

```bash
./scripts/create-vite-react-ts.sh <project-name> [destination-folder]
```

Example (create next to this repo):

```bash
./scripts/create-vite-react-ts.sh your-new-app ..
```

After creation, move into the new project:

```bash
cd ../your-new-app
```

### 2) Apply the scaffold (testing + structure)

Run this **inside the generated project folder**:

```bash
/path/to/this-repo/scripts/apply-scaffold.sh
```

## What the scaffold adds

### Unit and Component Testing

- Vitest + jsdom
- React Testing Library
- jest-dom matchers
- user-event
- Vite test configuration
- Test setup file
- Sanity test

Generated files:

- vite.config.ts
- src/test/setup.ts
- src/App.test.tsx

Scripts added:

```bash
npm test
npm run test:run
```

---

### Minimal API Boundary

A small API layer is added to encourage clean separation between UI and data access:

- src/api/http.ts — typed getJSON<T>() helper
- src/api/client.ts — example API client

## After Scaffolding

Once setup is complete, you can run:

```bash
npm run dev
npm test
npm run build
```

## GitHub Actions (CI)

This repository includes a minimal CI workflow:

```
.github/workflows/ci.yml
```

The workflow runs on every push and pull request:

- npm ci
- npm run test:run
- npm run build

### Enabling CI in a Generated Project

1. Copy `.github/workflows/ci.yml` into the generated project
2. Push the project to GitHub
3. Open the **Actions** tab to verify CI runs
