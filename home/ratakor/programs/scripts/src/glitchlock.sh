# based on https://github.com/xero/glitchlock

grim /tmp/lock.png
magick /tmp/lock.png /tmp/lock.jpg
file=/tmp/lock.jpg

datamosh() {
	file_size=$(wc -c < "$file")
	header_size=1000
	skip=$(shuf -i "$header_size"-"$file_size" -n 1)
	count=$(shuf -i 1-10 -n 1)
	byteStr=""
	for _ in $(seq 1 "$count"); do
		byteStr=$byteStr'\x'$(shuf -i 0-255 -n 1)
	done
	printf "%s" "$byteStr" |
		dd of="$file" bs=1 seek="$skip" count="$count" conv=notrunc >/dev/null 2>&1
}

steps=$(shuf -i 40-70 -n 1)
for _ in $(seq 1 "$steps"); do
	datamosh "$file"
done

magick /tmp/lock.jpg /tmp/lock.png >/dev/null 2>&1
rm /tmp/lock.jpg
file=/tmp/lock.png

timestamp=$(date +%F-%R:%S)
swaylock -i "$file" > "/tmp/swaylock-$timestamp.log" 2>&1
