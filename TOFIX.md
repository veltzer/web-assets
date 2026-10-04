# TOFIX

Findings from a code scan on 2026-10-04.

## Low

- `docs/raw/google_classroom_images/aws.jpg` - the file is a PNG (`file` reports image/png) with a `.jpg` extension, so it is served with the wrong Content-Type. Rename it to `aws.png` (and update whatever links to it).
- `docs/raw/propaganda/linux-windows.pnm` - an uncompressed Netpbm copy (500x375) of `docs/raw/propaganda/linux-windows.jpg` (same image, same size). Browsers cannot display PNM, so it is useless as a web asset; delete the leftover.
- `README.md:1` - heading is "# assets" but the repo is `web-assets`, and the README does not say that `docs/mermaid/` is generated from `mermaid/*.mmd` by `rsconstruct build` (via `scripts/mmdc-deterministic.sh`) while `docs/raw/` is hand-committed. Fix the title and document the layout and how to regenerate.
