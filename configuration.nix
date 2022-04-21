# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  powerManagement.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    hostName = "tanturi";
    extraHosts = "127.0.0.1 tanturi";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ 8080 ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  hardware.cpu.intel.updateMicrocode= true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Fix broken built-in microphone
  #### TODO: TRY
  # hardware.firmware = with pkgs; [ sof-firmware ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Sound stuff (including Bluetooth headset)
  # See https://nixos.wiki/wiki/Bluetooth
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-bluetooth-policy auto_switch=2
    '';
    support32Bit = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.logind.lidSwitch = "suspend-then-hibernate";

  # Control screen brightness
  programs.light.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  services.openssh.enable = true;
  services.fwupd.enable = true;
  services.lorri.enable = true;

  # Necessary even though activated in Home Manager
  programs.gnupg.agent.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    desktopManager.session = [{
      name = "home-manager";
      start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
      '';
    }];

    displayManager.lightdm.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        accelSpeed = "1.0";
      };
    };

    # affects the login screen
    dpi = 200;
  };

  # See https://nixos.wiki/wiki/I3 on saving settings for some applications, like Firefox
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  nix = {
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    binaryCaches = [ "https://hydra.iohk.io" ];
    settings.trusted-users = ["root" "teo"];
  };

  users.users.teo = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user
      "networkmanager" # Enable changing network settings like wifi
      "docker" # Enable using Docker
      "users" # Control users
    ];
    # shell = ..
  };

  fonts.fonts = with pkgs; [
    source-code-pro
    fira
    fira-code
    fira-code-symbols
    fira-mono
    font-awesome_5
    emacs-all-the-icons-fonts
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "21.11";

}
