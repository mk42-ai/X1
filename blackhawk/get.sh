#!/usr/bin/env bash
# Reassembles Sikorsky_UH-60_Black_Hawk.rar from 5 parts hosted on GitHub raw
set -euo pipefail
BASE="https://raw.githubusercontent.com/mk42-ai/X1/main/blackhawk"
OUT="Sikorsky_UH-60_Black_Hawk.rar"
EXPECTED="209cbceee60bdc23172bec20c197e4a7e423d89f425698933236ee345c499d92"
: > "$OUT"
for i in 00 01 02 03 04; do
  echo "part $i ..."
  curl -fL --retry 3 "$BASE/$OUT.part$i" >> "$OUT"
done
if command -v sha256sum >/dev/null; then GOT=$(sha256sum "$OUT" | cut -d' ' -f1); else GOT=$(shasum -a 256 "$OUT" | cut -d' ' -f1); fi
echo "sha256: $GOT"
[ "$GOT" = "$EXPECTED" ] && echo "OK: $OUT verified ($(du -h "$OUT" | cut -f1))" || { echo "MISMATCH — expected $EXPECTED"; exit 1; }
