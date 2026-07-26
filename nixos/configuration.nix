{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # Never change

  # ===============================================

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-132b";                  # ter-124b?
    keyMap = "us";
    #useXkbConfig = true; 
    packages = with pkgs; [ terminus_font ];
  };

  programs.nix-ld.enable = true;

  networking.hostName = "r04";          # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  security.sudo.wheelNeedsPassword = false;
  security.sudo.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    tmux
    zsh
    gcc
    nodejs
    python3
    go
    rustup
    ncdu
    htop
    curl
    tree
    udev
    iotop
    unzip
    fastfetch
    jq
    fzf
    ripgrep
    nmap
    sshfs
    eza
    bat
    lldb
    terminus_font
    jetbrains-mono

    bison
    flex
    fontforge
    makeWrapper
    pkg-config
    gnumake
    libiconv
    autoconf
    automake
    libtool
    busybox
  ];

  services.kmscon = {
    enable = true;
    extraConfig = ''
      font-name=JetBrainsMono Nerd Font
      font-size=22
      xkb-layout=us
    '';
  };

  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.UseDns = false;

  networking.wireless = {
    enable = true;
    networks = {
      SSID = {
        psk = "PASSWORD";
      };
    };
  };

  # ====================================
  # For the home directory

  users.users.bus710 = {
    isNormalUser = true;
    createHome = true;
    home = "/home/bus710";
    extraGroups = [ "wheel" ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];
}

