#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f package.json ]]; then
  echo "Run this inside the app folder (package.json not found)."
  exit 1
fi

log() {
  echo ""
  echo "▶ $1"
}

log "Installing Vitest + React Testing Library"

npm i -D vitest jsdom \
  @testing-library/react \
  @testing-library/jest-dom \
  @testing-library/user-event \
  @types/node

log "Configuring TypeScript for Vitest"

node - <<'EOF'
const fs = require("fs");

const path = "tsconfig.json";
const tsconfig = JSON.parse(fs.readFileSync(path, "utf8"));

tsconfig.compilerOptions ||= {};
tsconfig.compilerOptions.types ||= [];

for (const t of ["node"]) {
  if (!tsconfig.compilerOptions.types.includes(t)) {
    tsconfig.compilerOptions.types.push(t);
  }
}

fs.writeFileSync(path, JSON.stringify(tsconfig, null, 2) + "\n");
EOF

log "Adding Vitest globals reference"

cat > src/vitest-env.d.ts <<'EOF'
/// <reference types="vitest/globals" />
EOF

log "Writing Vite test config"

cat > vite.config.ts <<'EOF'
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
    setupFiles: "./src/test/setup.ts",
    globals: true,
    css: true,
  },
});
EOF

log "Adding test setup + sanity test"

mkdir -p src/test

cat > src/test/setup.ts <<'EOF'
import "@testing-library/jest-dom";
EOF

cat > src/App.test.tsx <<'EOF'
import { render, screen } from "@testing-library/react";
import App from "./App";

it("renders the Vite + React heading", () => {
  render(<App />);
  expect(screen.getByText(/vite \+ react/i)).toBeInTheDocument();
});
EOF

log "Adding minimal API boundary"

mkdir -p src/api

cat > src/api/http.ts <<'EOF'
export async function getJSON<T>(url: string): Promise<T> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`HTTP ${res.status}: ${url}`);
  return res.json();
}
EOF

cat > src/api/client.ts <<'EOF'
import { getJSON } from "./http";

export type Health = { status: "ok" };

export function fetchHealth() {
  return getJSON<Health>("/api/health");
}
EOF

log "Patching package.json scripts"

node - <<'EOF'
const fs = require("fs");

const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));

pkg.scripts ||= {};
pkg.scripts.test = "vitest";
pkg.scripts["test:run"] = "vitest run";

fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2) + "\n");
EOF

log "Running unit tests"

npm test --silent

log "Done"

echo "✅ Scaffold completed. Try: npm test, npm run test:run, npm run build"
