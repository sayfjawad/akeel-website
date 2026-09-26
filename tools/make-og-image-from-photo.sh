#!/bin/bash
# Turns one of your own photos into the social preview card (1200x630).
#
#   bash tools/make-og-image-from-photo.sh /pad/naar/jouw-foto.jpg
#   bash tools/make-og-image-from-photo.sh jouw-foto.jpg /tmp/probeer-eerst.jpg
#
# The photo fills the card and gets the wordmark in a soft dark green band, so the
# preview still says who you are in small thumbnails. Without a second argument the
# result replaces assets/img/og-image.jpg — exactly the file the page points at.
set -euo pipefail

PHOTO="${1:-}"
if [ -z "$PHOTO" ] || [ ! -f "$PHOTO" ]; then
  echo "Gebruik: bash tools/make-og-image-from-photo.sh <foto.jpg> [uitvoer.jpg]" >&2
  exit 1
fi

SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${2:-$SITE/assets/img/og-image.jpg}"
TXT="$(mktemp -d)"
trap 'rm -rf "$TXT"' EXIT
mkdir -p "$(dirname "$OUT")"

printf '%s' 'Velvet & Voltage'                               > "$TXT/brand.txt"
printf '%s' 'Coffee machines & e-bikes, repaired with care' > "$TXT/line1.txt"
printf '%s' 'akeel.sdai.nl'                                 > "$TXT/url.txt"

SANS=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
SERIF=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf

# [0] your photo   [1] flat --green background to blend into
# Where the photo has alpha 255 it shows through; where alpha drops to 13 the green base
# takes over. So the photo stays visible at the top and the wordmark sits on a solid
# green band from y=430 down, whatever the photo looks like behind it.
ffmpeg -hide_banner -loglevel error -y \
  -i "$PHOTO" \
  -f lavfi -i "color=c=0x174735:s=1200x630" \
  -filter_complex "\
[0:v]scale=1200:630:force_original_aspect_ratio=increase,crop=1200:630:0:0,setsar=1[photo];\
[photo]format=rgba,geq=\
r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='if(lte(Y,280),255,max(13,255-(Y-280)*242/150))'[shade];\
[1:v][shade]overlay=0:0[base];\
[base]drawbox=x=72:y=398:w=90:h=5:color=0xd7f36a:t=fill,\
drawtext=fontfile=$SERIF:textfile=$TXT/brand.txt:expansion=none:fontsize=76:fontcolor=0xf7f4e8:x=70:y=420,\
drawtext=fontfile=$SANS:textfile=$TXT/line1.txt:expansion=none:fontsize=28:fontcolor=0xd7f36a:x=72:y=514,\
drawtext=fontfile=$SANS:textfile=$TXT/url.txt:expansion=none:fontsize=28:fontcolor=0xd4dfd3:x=72:y=556,\
format=yuvj420p" \
  -frames:v 1 -q:v 3 "$OUT"

ls -l "$OUT"
ffprobe -hide_banner -v error -select_streams v:0 \
  -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 "$OUT"
