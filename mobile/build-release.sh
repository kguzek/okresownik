#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"

sed -i "s/^version:.*/version: $VERSION/" pubspec.yaml

flutter build apk --release --build-name="$VERSION" --build-number="$(echo "$VERSION" | tr -cd '0-9')"

for f in build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/app-*-release.apk; do
  [ -f "$f" ] || continue
  base=$(basename "$f")
  suffix=$(echo "$base" | sed -E 's/app(-.*)?-release\.apk/\1/; s/^-//')
  if [ -n "$suffix" ]; then
    mv "$f" "build/app/outputs/flutter-apk/okresownik-v$VERSION-$suffix.apk"
  else
    mv "$f" "build/app/outputs/flutter-apk/okresownik-v$VERSION.apk"
  fi
done

flutter build appbundle --release --build-name="$VERSION" --build-number="$(echo "$VERSION" | tr -cd '0-9')"

mv build/app/outputs/bundle/release/app-release.aab "build/app/outputs/bundle/release/okresownik-v$VERSION.aab"
