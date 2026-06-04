# shellcheck shell=sh

printf 'Generating a random ID...\n'
id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
printf 'Image ID: %s\n' "$id"

printf 'Taking screenshot...\n'
grim -g "$(slurp -w 0 -b eebebed2)" "/tmp/ocr-$id.png"

printf 'Running OCR...\n'
tesseract "/tmp/ocr-$id.png" - | wl-copy
printf 'File saved to /tmp/ocr-%s.png\n' "$id"

printf 'Sending notification...\n'
notify-send "OCR " "Text copied!"

printf 'Cleaning up...\n'
rm -vf "/tmp/ocr-$id.png"
