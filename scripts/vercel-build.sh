#!/usr/bin/env bash
set -euo pipefail

FLUTTER_ROOT="${HOME}/flutter-3.47.9"

if [[ ! -x "${FLUTTER_ROOT}/bin/flutter" ]]; then
  echo "Flutter SDK no encontrado. Ejecuta primero scripts/vercel-install.sh." >&2
  exit 1
fi

"${FLUTTER_ROOT}/bin/flutter" build web --release
