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
    font = "Lat2-Terminus32";
    keyMap = "us";
    #useXkbConfig = true; 
  };

  programs.nix-ld.enable = true;

  networking.hostName = "r04"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

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
    cargo
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

    docker-compose
  ];

  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.UseDns = false;

  virtualisation.docker.enable = true;

  networking.wireless = {
    enable = true;
    networks = {
      SSID = {
        psk = "PASSWORD";
      };
    };
  };


  # ====================================
  users.users.bus710 = {
    isNormalUser = true;
    createHome = true;
    home = "/home/bus710";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  security.sudo.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}

