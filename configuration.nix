{ config, pkgs, ... }: {

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    boot.initrd.luks.devices."luks-02f056e5-32ae-4b97-b890-02e378279efa".device = "/dev/disk/by-uuid/02f056e5-32ae-4b97-b890-02e378279efa";
    boot.initrd.luks.devices."luks-02f056e5-32ae-4b97-b890-02e378279efa".keyFile = "/crypto_keyfile.bin";

    networking.hostName = "marcus-laptop";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/London";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    programs.light.enable = true;

    services.xserver.enable = true;
    services.xserver.autorun = false;

    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;

    # services.xserver.displayManager.lightdm.enable = true;

    programs.fish.enable = true;

    services.xserver = {
      layout = "gb";
      xkbVariant = "";
    };
    console.keyMap = "uk";
    services.printing.enable = true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    security.sudo.wheelNeedsPassword = false;
    users.users.marcus = {
      isNormalUser = true;
      description = "Marcus Whybrow";
      extraGroups = [ "networkmanager" "wheel" "video" ];
      shell = pkgs.fish;
      packages = with pkgs; [
        firefox
      #  thunderbird
      ];
    };

    # Enable automatic login for the user.
    #services.xserver.displayManager.autoLogin.enable = true;
    #services.xserver.displayManager.autoLogin.user = "marcus";
  
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    #systemd.services."getty@tty1".enable = false;
    #systemd.services."autovt@tty1".enable = false;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
       neovim
       git
       gh

       fish
       wget
       unixtools.ping
       pamixer
       wlogout

       trashy
       bat
       exa
       fd
       procs
       sd
       du-dust
       ripgrep
       ripgrep-all
       tealdeer
       bandwhich
       delta

       coreboot-configurator
       # megasync
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };

}
