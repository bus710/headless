#!/bin/bash

set -e

# Remove leftover desktop environments (Cinnamon, GNOME, LightDM, ...) that a Debian
# installer's task selection can drop onto a machine you intend to run bare Sway
# on. This is DESTRUCTIVE and machine-specific, so it is deliberately NOT part of
# the normal sway install (01_sway.sh) - run it by hand, only on a box that
# actually has DE remnants.
#
# How the remnant was diagnosed on t03: `apt-get install -s libc6` (or any other
# already-installed package) kept listing the same pending Cinnamon libs
# (liblightdm-gobject-1-0, libcjs0->libmozjs, libgoa-backend->librest) no matter
# what was being installed - they were Cinnamon's pending Recommends, not from
# the sway/fcitx scripts.

# Package-name patterns to purge. These are apt "~n" patterns: regex matched
# anywhere in the package NAME. Extend as needed for other installer DEs, e.g.
#   "~nplasma-desktop"  "~nmate-desktop"  "~nxfce4-session"  "~ntask-.*-desktop"
#
# NOTE the GNOME targets are deliberately specific (shell / session / gdm3) - do
# NOT add a bare "~ngnome". That would also nuke gnome-keyring / gnome-themes /
# libgnome* that Sway and GTK apps legitimately use. The preview step always
# shows the full removal list before anything is purged, so review it.
DE_PATTERNS=(
    "~ncinnamon"
    "~ngnome-shell"
    "~ngnome-session"
    "~ngdm3"
    "~nlightdm"
)

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

cleanup_home (){
    rm -rf ~/Desktop ~/Documents ~/Music ~/Pictures ~/Projects ~/Public ~/Templates ~/Video
}

# Print what would be purged; return non-zero if nothing matches.
preview_removal (){
    term_color_red
    echo "Checking for leftover desktop-environment packages..."
    term_color_white

    # -s = simulate (no root needed). Keep only the actual removal lines.
    local out
    out=$(apt-get purge -s "${DE_PATTERNS[@]}" 2>/dev/null | grep -E '^(Purg|Remv) ' || true)

    if [[ -z "$out" ]]; then
        return 1
    fi

    term_color_red
    echo "The following packages would be PURGED:"
    term_color_white
    echo "$out"
    echo
    return 0
}

confirmation (){
    term_color_red
    echo "Purge the packages listed above (plus orphaned deps)?"
    echo "This is destructive. Only do this on a machine meant for bare Sway."
    echo
    echo "Continue? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo
        exit 1
    fi

    sudo echo ""
}

remove_desktop_environments (){
    term_color_red
    echo "Purging desktop-environment packages"
    term_color_white

    sudo apt purge -y "${DE_PATTERNS[@]}"

    term_color_red
    echo "Sweeping orphaned dependencies"
    term_color_white

    sudo apt autoremove --purge -y
}

verify (){
    term_color_red
    echo "Verify (should report clean):"
    term_color_white

    if apt-get install -s libc6 2>/dev/null | grep -iE 'lightdm|gnome-shell|cinnamon'; then
        term_color_red
        echo "- still some pending DE libs above; re-run or extend DE_PATTERNS"
        term_color_white
    else
        echo "- clean: no pending lightdm/gnome/cinnamon DE libs"
    fi
}

post (){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT

cleanup_home

if ! preview_removal; then
    term_color_red
    echo "No matching desktop-environment packages installed. Nothing to do."
    term_color_white
    exit 0
fi

confirmation
remove_desktop_environments
verify
post


