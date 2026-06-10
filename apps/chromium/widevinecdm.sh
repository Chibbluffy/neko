#!/usr/bin/env bash
set -e

TARGET_DIR="$(realpath "$1")"
if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 /path/to/install/WidevineCdm"
    exit 1
fi

ARCH=$(dpkg --print-architecture)
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

function cleanup {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

if [ "${ARCH}" = "amd64" ]; then
    # Fetch Widevine CRX from Mozilla's Gecko manifest (x86_64 only)
    URL=$(python3 -c "
import json, urllib.request
data = json.load(urllib.request.urlopen('https://raw.githubusercontent.com/mozilla/gecko-dev/master/toolkit/content/gmp-sources/widevinecdm.json'))
for v in data['vendors'].values():
    for k, p in v['platforms'].items():
        if 'Linux_x86_64-gcc3' in k:
            print(p['fileUrl'])
            break
")

    # Download CRX
    curl -L -o widevinecdm.crx "$URL"

    # Install go-crx3
    echo "Fetching latest go-crx3 version..."
    VERSION=$(curl -s https://api.github.com/repos/m1k1o/go-crx3/releases/latest | grep 'tag_name' | cut -d '"' -f4)
    ARTIFACT="go-crx3_${VERSION#v}_linux_amd64.tar.gz"
    URL="https://github.com/m1k1o/go-crx3/releases/download/${VERSION}/${ARTIFACT}"
    echo "Downloading $URL"
    curl -L -o "$ARTIFACT" "$URL"
    tar -xzf "$ARTIFACT"

    # Unpack with go-crx3
    ./go-crx3 unpack widevinecdm.crx
    mkdir -p "$TARGET_DIR"
    cp -ar widevinecdm/* "$TARGET_DIR"

elif [ "${ARCH}" = "arm64" ]; then
    # Extract Widevine from a ChromeOS LaCrOS ARM64 squashfs image.
    # Google does not publish a native Linux ARM64 Widevine binary, but the
    # ChromeOS ARM64 LaCrOS image contains one. widevine_fixup.py (MIT license,
    # David Buchanan / Asahi Linux) patches the ELF to load on standard Linux.
    # Note: on kernels with 64K page size the patch weakens RELRO and creates
    # an RWX mapping. See widevine_fixup.py for full details.
    LACROS_VERSION="${LACROS_VERSION:-120.0.6098.0}"
    LACROS_URL="https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${LACROS_VERSION}"

    echo "Downloading ChromeOS LaCrOS image (${LACROS_VERSION}) — this is ~500 MB, please wait..."
    curl -L -o lacros.squashfs "${LACROS_URL}"

    echo "Extracting WidevineCdm from squashfs..."
    unsquashfs -q lacros.squashfs 'WidevineCdm/*'

    echo "Patching Widevine library for standard Linux ARM64 compatibility..."
    python3 /widevine_fixup.py \
        squashfs-root/WidevineCdm/_platform_specific/cros_arm64/libwidevinecdm.so \
        libwidevinecdm.so

    mkdir -p "${TARGET_DIR}/_platform_specific/linux_arm64"
    cp libwidevinecdm.so "${TARGET_DIR}/_platform_specific/linux_arm64/"
    chmod 755 "${TARGET_DIR}/_platform_specific/linux_arm64/libwidevinecdm.so"
    cp squashfs-root/WidevineCdm/manifest.json "${TARGET_DIR}/"

    # Chromium on ARM64 still checks for linux_x64 to exist before loading the CDM.
    # A zero-byte placeholder satisfies the check without wasting space.
    mkdir -p "${TARGET_DIR}/_platform_specific/linux_x64"
    touch "${TARGET_DIR}/_platform_specific/linux_x64/libwidevinecdm.so"

    echo "Widevine installed to ${TARGET_DIR}"
else
    echo "Widevine is not supported on ${ARCH}"
    exit 1
fi
