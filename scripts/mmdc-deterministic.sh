#!/bin/bash -eu
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
	case "${prev}" in
	-o | --output) out="${arg}" ;;
	esac
	prev="${arg}"
done

# mmdc comes from package.json, installed into node_modules by
# `rsconstruct tools install-deps`; rsconstruct puts node_modules/.bin on
# PATH before it runs this script, so a plain invocation resolves it.
mmdc "$@"

case "${out}" in
*.pdf)
	perl -0777 -pi -e \
		"s{(/(?:Creation|Mod)Date \(D:)\d{14}[+-]\d{2}'\d{2}'}{\${1}19700101000000+00'00'}g" \
		"${out}"
	;;
esac
