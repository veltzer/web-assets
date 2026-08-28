#!/bin/bash
# mmdc wrapper that makes PDF output reproducible.
#
# Chromium's Skia PDF writer stamps the wall-clock time into /CreationDate
# and /ModDate (and ignores SOURCE_DATE_EPOCH), so every render of the same
# diagram is binary-different. The committed docs/mermaid assets must be
# stable, so after rendering we pin both dates to the epoch. The replacement
# is byte-length-preserving, which keeps the xref offsets valid.
set -euo pipefail

out=""
prev=""
for arg in "$@"; do
	case "$prev" in
		-o|--output) out="$arg" ;;
	esac
	prev="$arg"
done

# Locally mmdc comes from package.json; in CI rsconstruct installs it
# globally. Prefer the repo-local one when present.
mmdc="mmdc"
if [ -x "node_modules/.bin/mmdc" ]; then
	mmdc="node_modules/.bin/mmdc"
fi

"$mmdc" "$@"

case "$out" in
	*.pdf)
		perl -0777 -pi -e \
			"s{(/(?:Creation|Mod)Date \(D:)\d{14}[+-]\d{2}'\d{2}'}{\${1}19700101000000+00'00'}g" \
			"$out"
		;;
esac
