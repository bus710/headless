#!/bin/bash

set -e

# Create a 16 GiB swapfile at /opt/swapfile, but only when the machine needs it.
# Need = low RAM AND low swap. If either RAM or swap is already ~16 GB we skip.
# https://bogdancornianu.com/change-swap-size-in-ubuntu/

SWAPFILE="/opt/swapfile"
SWAP_GB=16

# MemTotal/SwapTotal report a little under a nominal size (reserved memory), so
# compare against 15 GiB in kB to treat a real 16 GB box as "enough".
MIN_KB=$((15 * 1024 * 1024))

term_color_red()   { echo -e "\e[91m"; }
term_color_white() { echo -e "\e[39m"; }

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit 1
fi

# This swap advice targets x86_64 desktops/laptops; skip small-disk ARM boards.
arch="$(uname -m)"
if [[ "$arch" != "x86_64" ]]; then
    echo "Arch is ${arch} (not x86_64) - skipping swapfile setup."
    exit 0
fi

mem_kb=$(awk '/^MemTotal:/  {print $2}' /proc/meminfo)
swap_kb=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)

to_gib() { awk -v k="$1" 'BEGIN{printf "%.1f", k/1024/1024}'; }

echo
echo "RAM : $(to_gib "$mem_kb") GiB"
echo "Swap: $(to_gib "$swap_kb") GiB"
echo

# Decide whether a swapfile is needed. Skip as soon as RAM or swap is ample.
if (( mem_kb >= MIN_KB )) && (( swap_kb >= MIN_KB )); then
    echo "Already have >= 16 GB RAM and >= 16 GB swap - nothing to do."
    exit 0
elif (( mem_kb >= MIN_KB )); then
    echo "Have >= 16 GB RAM - swapfile not needed. Skipping."
    exit 0
elif (( swap_kb >= MIN_KB )); then
    echo "Already have >= 16 GB swap - skipping."
    exit 0
fi

confirmation() {
    term_color_red
    echo "RAM and swap are both under 16 GB."
    echo "Create a ${SWAP_GB} GiB swapfile at ${SWAPFILE}? (y/n)"
    term_color_white
    echo
    read -n 1 -r ans
    echo
    if [[ ! $ans == "y" ]]; then
        exit 1
    fi
}

create_swapfile() {
    # Drop an old/partial swapfile first so re-runs are idempotent.
    if swapon --show=NAME --noheadings 2>/dev/null | grep -qx "$SWAPFILE"; then
        echo "Turning off existing ${SWAPFILE}"
        sudo swapoff "$SWAPFILE"
    fi
    sudo rm -f "$SWAPFILE"

    echo
    echo "Creating ${SWAP_GB} GiB ${SWAPFILE} (this takes ~30 seconds)"
    echo
    sudo dd if=/dev/zero of="$SWAPFILE" bs=1G count="$SWAP_GB" status=progress
    sudo chmod 0600 "$SWAPFILE"
    sudo mkswap "$SWAPFILE"

    echo
    echo "Enabling swap"
    echo
    sudo swapon "$SWAPFILE"
}

configure_fstab() {
    if grep -qs "^${SWAPFILE}[[:space:]]" /etc/fstab; then
        echo "fstab already has an entry for ${SWAPFILE}"
    else
        echo "Adding ${SWAPFILE} to /etc/fstab"
        echo "${SWAPFILE}    none    swap    sw    0    0" | sudo tee -a /etc/fstab >/dev/null
    fi
}

post() {
    echo
    echo "Done. Current swap:"
    grep -E 'SwapTotal|SwapFree' /proc/meminfo
    echo
    echo "Persisted in /etc/fstab - it will auto-enable on next boot."
    echo
}

trap term_color_white EXIT

confirmation
create_swapfile
configure_fstab
post
