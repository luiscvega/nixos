{pkgs, ...}: {
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [8081];
  };

  # Locale
  time.timeZone = "Asia/Manila";

  i18n.defaultLocale = "en_PH.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    excludePackages = with pkgs; [xterm];
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    gnome-maps
    gnome-music
    gnome-weather
  ];

  # Audio
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Services
  services.printing.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    extensions = ps: [ps.pgvector];
  };

  services.tailscale.enable = true;

  virtualisation.docker.enable = true;

  # Users
  users.users.luis = {
    isNormalUser = true;
    description = "luis";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  # System
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.noisetorch.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "24.11";
}
