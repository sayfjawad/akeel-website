#!/bin/bash
# Makes the social preview card (assets/img/og-image.jpg, 1200x630) in the site colours.
#
#   bash tools/make-og-image.sh
#
# Needs ffmpeg. Change the words or the colours below and run it again; the page itself
# never has to change, because it always points at assets/img/og-image.jpg.
#
# Want your own photo instead? One command is enough (same filename, no code change):
#   ffmpeg -i jouw-foto.jpg \
#     -vf "scale=1200:630:force_original_aspect_ratio=increase,crop=1200:630:0:0" \
#     -q:v 3 assets/img/og-image.jpg
#
# Want your photo plus the wordmark on it? Use tools/make-og-image-from-photo.sh instead.
set -euo pipefail

SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$SITE/assets/img/og-image.jpg"
TXT="$(mktemp -d)"
trap 'rm -rf "$TXT"' EXIT
mkdir -p "$(dirname "$OUT")"

# Text goes through files so nothing has to be escaped for ffmpeg (&, spaces, apostrophes).
printf '%s' 'INDEPENDENT REPAIR & MAINTENANCE' > "$TXT/eyebrow.txt"
printf '%s' 'Velvet & Voltage'                 > "$TXT/brand.txt"
printf '%s' 'Coffee machines & e-bikes,'       > "$TXT/line1.txt"
printf '%s' 'repaired with care.'              > "$TXT/line2.txt"
printf '%s' 'akeel.sdai.nl'                    > "$TXT/url.txt"

SANS=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf     # stand-in for --sans
SERIF=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf   # stand-in for Georgia

# Colours from assets/css/style.css:
#   --green #174735 -> r23  g71  b53
#   --lime  #d7f36a -> r215 g243 b106
#   heading #f7f4e8 -> r247 g244 b232
# The lime disc top-right echoes .art-sun in the hero illustration.
ffmpeg -hide_banner -loglevel error -y \
  -f lavfi -i "color=c=0x174735:s=1200x630" \
  -vf "format=rgb24,\
geq=r='if(lte(pow(X-1082,2)+pow(Y-104,2),19600),215,23)'\
:g='if(lte(pow(X-1082,2)+pow(Y-104,2),19600),243,71)'\
:b='if(lte(pow(X-1082,2)+pow(Y-104,2),19600),106,53)',\
drawtext=fontfile=$SANS:textfile=$TXT/eyebrow.txt:expansion=none:fontsize=26:fontcolor=0xd7f36a:x=(w-text_w)/2:y=134,\
drawbox=x=(iw-140)/2:y=198:w=140:h=6:color=0xd7f36a:t=fill,\
drawtext=fontfile=$SERIF:textfile=$TXT/brand.txt:expansion=none:fontsize=94:fontcolor=0xf7f4e8:x=(w-text_w)/2:y=254,\
drawtext=fontfile=$SANS:textfile=$TXT/line1.txt:expansion=none:fontsize=40:fontcolor=0xd4dfd3:x=(w-text_w)/2:y=404,\
drawtext=fontfile=$SANS:textfile=$TXT/line2.txt:expansion=none:fontsize=40:fontcolor=0xd4dfd3:x=(w-text_w)/2:y=458,\
drawtext=fontfile=$SANS:textfile=$TXT/url.txt:expansion=none:fontsize=28:fontcolor=0xd7f36a:x=(w-text_w)/2:y=552,\
format=yuvj420p" \
  -frames:v 1 -q:v 3 "$OUT"

ls -l "$OUT"
ffprobe -hide_banner -v error -select_streams v:0 \
  -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 "$OUT"
