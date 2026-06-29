#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"

sed -i "s/^version:.*/version: $VERSION/" pubspec.yaml

# Decode keystore from env if present (CI)
if [ -n "${KEYSTORE_BASE64:-}" ]; then
  KEYSTORE_PATH="$(mktemp -d)/keystore.jks"
  echo "$KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_PATH"
  export KEYSTORE_PATH
fi

flutter build apk --release --build-name="$VERSION" --build-number="$(echo "$VERSION" | tr -cd '0-9')"

for f in build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/app-*-release.apk; do
  [ -f "$f" ] || continue
  base=$(basename "$f")
  suffix=$(echo "$base" | sed -E 's/app(-.*)?-release\.apk/\1/; s/^-//')
  if [ -n "$suffix" ]; then
    mv "$f" "build/app/outputs/flutter-apk/okresownik-$suffix.apk"
  else
    mv "$f" "build/app/outputs/flutter-apk/okresownik.apk"
  fi
done

flutter build appbundle --release --build-name="$VERSION" --build-number="$(echo "$VERSION" | tr -cd '0-9')"

mv build/app/outputs/bundle/release/app-release.aab "build/app/outputs/bundle/release/okresownik.aab"
