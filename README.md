# Headless

Bootstrap scripts for a headless-first Debian dev machine. Each script is
standalone, prompts before making changes, and is numbered so they read in a
sensible install order.

## Install order

Run the numbered scripts as a normal user (they call `sudo` where needed):

### Base system (`00`–`22`)

| Script | What it does |
|--------|--------------|
| `00_git_setup.sh` | Global git config |
| `01_shrc.sh` | Shell runcom (`~/.shrc`) |
| `02_basics.sh` | Basic apt packages |
| `03_zsh.sh` | Zsh + oh-my-zsh |
| `04_tmux.sh` | tmux + tmuxp |
| `20_basic_build_tools.sh` | Compilers / build essentials |
| `22_tui_tools.sh` | Misc TUI/CLI tools |

### Language SDKs (`30`–`34`) — cores only

Install the runtime/compiler and wire up `PATH`. Node lands before nvim so its
LSP servers exist by the time the editor is set up.

| Script | SDK |
|--------|-----|
| `30_node.sh` | nvm + Node LTS |
| `31_python.sh` | uv + a uv-managed Python |
| `32_go.sh` | Go toolchain |
| `33_rust.sh` | rustup + stable toolchain |
| `34_zig.sh` | Zig + zls (uses `sdk/zig/zls.json`) |

### SDK tooling (`40`)

| Script | What it does |
|--------|--------------|
| `40_sdk_tools.sh` | Post-install tooling for node / python / go / rust in one pass. Each language is a wrapped section, so one failure doesn't abort the rest. |

### Editor (`50`–`51`) — runs last

Depends on every SDK above (LSPs, formatters, DAP adapters).

| Script | What it does |
|--------|--------------|
| `50_nvim.sh` | Neovim |
| `51_astro_nvim.sh` | AstroNvim config + utils |

### Local config (`60`–`62`)

Machine-local hardware/system tweaks.

| Script | What it does |
|--------|--------------|
| `60_network_udev_rule.sh` | Pin NICs to `eth0` / `wlan0` by MAC (writes a persistent-net udev rule) |
| `61_cpu_gpu_low_freq_cron_rule.sh` | Cap CPU/GPU max frequency via a root helper + cron. GPU handling is driver-aware (amdgpu / i915 / xe / devfreq) |
| `62_swap_16gb.sh` | Create a 16 GB swapfile (`/opt/swapfile`) and enable it |

### External services (`90`)

| Script | What it does |
|--------|--------------|
| `90_external_services.sh` | Tailscale (mesh VPN) + Claude Code (Anthropic CLI) |

## Layout

- `sdk/` — SDKs outside the daily core:
  - `sdk/embedded/` — rust-embedded, esp32, arduino
  - `sdk/android/`, `sdk/flutter/`, `sdk/zig/` (zls template)
- `sway/` — Sway desktop setup: install/config scripts (compositor, fcitx, keyring, chrome, vscode, waydroid, etc.) plus `sway/dotfiles/` (sway config, waybar, wofi, kitty) copied into place
- `infra/` — infrastructure snippets
- `archlinux/` — Arch-specific notes/scripts
- `shrc`, `tmux.conf` — dotfiles copied into place by the base scripts
