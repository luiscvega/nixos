{
  config,
  pkgs,
  lib,
  options,
  specialArgs,
  modulesPath,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

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

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    kgx
    gnome-maps
    gnome-music
    gnome-weather
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    extensions = ps: [ps.pgvector];
  };

  services.tailscale = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.luis = {
    isNormalUser = true;
    description = "luis";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  programs.bash.promptInit = ''
    PS1="\w\[\e[31m\]\\$\[\e[m\] "
  '';

  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.noisetorch.enable = true;

  environment.systemPackages = [
    pkgs.slack
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11"; # Did you read the comment?
}
