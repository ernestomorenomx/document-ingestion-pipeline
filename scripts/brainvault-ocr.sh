#!/bin/bash
#!/bin/bash
PDF_PATH="$1"
TMP_DIR=$(mktemp -d)

# Asegura que TMP_DIR se borre SIEMPRE al salir, sin importar cómo termine el script
trap 'rm -rf "$TMP_DIR"' EXIT

# Resolución reducida (150 DPI es suficiente para texto, mucho más rápido que 300)
timeout 60 pdftoppm -r 150 "$PDF_PATH" "$TMP_DIR/page"

RESULT=""
PAGE_COUNT=0
MAX_PAGES=20

for IMG in $(ls "$TMP_DIR"/page-*.ppm 2>/dev/null | sort); do
  PAGE_COUNT=$((PAGE_COUNT + 1))
  if [ "$PAGE_COUNT" -gt "$MAX_PAGES" ]; then
    break
  fi
  # Máximo 30 segundos por página; si se cuelga, sigue con la siguiente
  TEXT=$(timeout 30 tesseract "$IMG" stdout -l spa+eng 2>/dev/null)
  RESULT="$RESULT\n$TEXT"
done

echo -e "$RESULT"
