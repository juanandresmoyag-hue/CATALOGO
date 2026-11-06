#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.9"
FLUTTER_ROOT="${HOME}/flutter-${FLUTTER_VERSION}"

if [[ ! -x "${FLUTTER_ROOT}/bin/flutter" ]]; then
  git clone --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"
fi

export PATH="${FLUTTER_ROOT}/bin:${PATH}"

flutter config --no-analytics
flutter precache --web
flutter pub get
