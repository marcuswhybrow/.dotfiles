outputs: pkgs: {
  theme = "light";
  fullName = "Marcus Whybrow";
  groups = [ "networkmanager" "wheel" "video" ];
  shell = pkgs.fish;
  git = { 
    enable = true;
    userName = "Marcus Whybrow";
    userEmail = "marcus@whybrow.uk";
  };
  sway = {
    enable = true;
    terminal = "alacritty";
    disableBars = true;
  };
  waybar.enable = true;
  neovim.enable = true;
  rofi.enable = true;
  alacritty.enable = true;
  packages = with pkgs; [
    # htop requires lsof when you press `l` on a process
    htop lsof

    brave
    vimb
    discord
    obsidian

    # Testing various tiling window managers
    cagebreak 
    river
    cardboard # scrolling wm
    dwl foot # suckless
    # Hyperland requires nixos-unstable
    # github:jbuchermn/newm#newm
    #outputs.newm
    qtile
    # https://github.com/michaelforney/velox
    # https://github.com/inclement/vivarium
    # https://github.com/waymonad/waymonad
  ];
  audio.volume.step = 5;
  display.brightness.step = 5;
  extraHomeManagerConfig = {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        c = ''vim ~/.dotfiles/systems/(hostname).nix'';
        d = ''cd ~/.dotfiles'';
      };
    };
    programs.starship.enable = true;
    xdg.configFile."river/init" = {
      text = ''
        #!/run/current-system/sw/bin/sh
        ${builtins.readFile (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/riverwm/river/0.2.x/example/init";
          sha256 = "sha256:0dmk29gak0hqb6ghpzrqd15g0vmsk10wzkiw9qhz5l7gb0mfdsxf";
        })}
        riverctl map normal Super T spawn alacritty
      '';
      executable = true;
    };
    xdg.configFile."cardboard/cardboardrc" = {
      text = ''
        #!/run/current-system/sw/bin/sh

        alias cutter=${pkgs.cardboard}/bin/cutter

        mod=alt

        cutter config mouse_mod $mod

        cutter bind $mod+shift+e quit
        cutter bind $mod+return exec alacritty
        cutter bind $mod+left focus left
        cutter bind $mod+right focus right
        cutter bind $mod+shift+left move -10 0
        cutter bind $mod+shift+right move 10 0
        cutter bind $mod+shift+up move 0 -10
        cutter bind $mod+shift+down move 0 10
        cutter bind $mod+shift+q close
        for i in $(seq 1 6); do
                cutter bind $mod+$i workspace switch $(( i - 1 ))
                cutter bind $mod+ctrl+$i workspace move $(( i - 1 ))
        done

        cutter bind $mod+shift+space toggle_floating
      '';
      executable = true;
    };

    # https://rycee.gitlab.io/home-manager/index.html#_how_do_i_override_the_package_used_by_a_module
    /*
    nixpkgs.overlays = [
      (self: super: {
        # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/applications/window-managers/dwl/default.nix#L14
        dwl = super.dwl.override {
          #conf = builtins.replaceStrings [ "foot" ] [ "alacritty" ] dwlDefaultConf;
          conf = dwlDefaultConf;
        };
      })
    ]; */
  };
}
