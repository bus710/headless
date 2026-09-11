#!/bin/bash

set -e

# Post-install step for zsh. Inserts the ssh-keychain block at the TOP of ~/.zshrc.
#
# Run this AFTER 03_zsh.sh AND AFTER 'p10k configure'. The block must sit ABOVE the
# p10k instant-prompt block: p10k forbids console input after instant prompt starts,
# and ssh-add needs the tty to prompt for a key passphrase. Idempotent — skips if
# the block is already present.

if [[ "$EUID" == 0 ]]; then
    echo "Please run without sudo"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

MARKER_BEGIN="# >>> ssh-keychain (managed by 04_zsh_post.sh) >>>"

install_ssh_keychain_block(){
    local zshrc="/home/$LOGNAME/.zshrc"
    [ -f "$zshrc" ] || { echo "No ~/.zshrc found; run 03_zsh.sh first."; return 1; }

    if grep -qF "$MARKER_BEGIN" "$zshrc"; then
        echo "ssh-keychain block already present in ~/.zshrc; skipping."
        return 0
    fi

    # Refuse to run before 'p10k configure': otherwise this block lands at the top
    # now, but 'p10k configure' would later prepend the instant-prompt block above
    # it, and the skip-if-present guard would keep it stuck in the wrong order.
    if ! grep -q "Enable Powerlevel10k instant prompt" "$zshrc"; then
        term_color_red
        echo "No p10k instant-prompt block in ~/.zshrc."
        echo "Run 'p10k configure' first (so this block lands above it), then re-run me."
        term_color_white
        return 1
    fi

    cat > "$zshrc.tmp" <<'EOF'
# >>> ssh-keychain (managed by 04_zsh_post.sh) >>>
# Load ssh keys at the top of ~/.zshrc, ABOVE the p10k instant-prompt block:
# p10k forbids console input after instant prompt starts, so ssh-add's passphrase
# prompt must run above it. Client-only (gated on ~/.env, which defines KEY00..03);
# servers have no ~/.env and skip this. keychain reuses one persistent agent, so
# this only prompts on the first shell after a reboot.
if [ -f "$HOME/.env" ]; then
  . "$HOME/.env"
  keychain --quiet "$KEY00" "$KEY01" "$KEY02" "$KEY03"
  source "$HOME/.keychain/$(hostname)-sh"
fi
# <<< ssh-keychain (managed by 04_zsh_post.sh) <<<

EOF
    cat "$zshrc" >> "$zshrc.tmp" && mv "$zshrc.tmp" "$zshrc"
    echo "Prepended ssh-keychain block to the top of ~/.zshrc."
}

trap term_color_white EXIT
install_ssh_keychain_block
echo
echo "Done"
