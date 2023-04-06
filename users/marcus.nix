{ config, lib, pkgs, ... }: {
  users.users.marcus = {
    description = "Marcus Whybrow";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.fish;
  };

  home-manager.users.marcus = {
    home.packages = with pkgs; [
      # htop requires lsof when you press `l` on a process
      htop lsof

      brave
      vimb
      discord
      obsidian

      plex-media-player

      swaybg
      wl-clipboard
      ranger

      networking

      dunst
    ];

    programs.brightness = {
      enable = true;
      onChange = ''
        echo "!$brightness!"
        ${pkgs.dunst}/bin/dunstify \
        --appname changeBrightness \
        --urgency low \
        --timeout 2000 \
        --hints string:x-dunst-stack-tag:brightness \
        --hints int:value:$brightness \
        "Brightness $brightness%"
      '';
    };

    programs.volume = {
      enable = true;
      onChange = ''
        ${pkgs.dunst}/bin/dunstify \
          --appname changeVolume \
          --urgency low \
          --timeout 2000 \
          --icon audio-volume-$([[ $isMuted == true ]] && echo "muted" || echo "high") \
          --hints string:x-dunst-stack-tag:volume \
          $([[ $isMuted == false ]] && echo "--hints int:value:$1") \
          "$([[ $isMuted == false ]] && echo "Volume: $volume%" || echo "Volume Muted")"
      '';
    };

    programs.logout.enable = true;

    themes.light = {
      enable = true;
      colors.waybar.primary = "1e88eb";
    };

    programs.fish = {
      enable = true;
      shellAbbrs = {
        c = ''vim ~/.dotfiles/systems/(hostname).nix'';
        d = ''cd ~/.dotfiles'';
        t = ''vim ~/obsidian/Personal/Timeline/(date +%Y-%m-%d).md'';
        y = ''vim ~/obsidian/Personal/Timeline/(date +%Y-%m-%d --date yesterday).md'';
      };
      functions = {
        timeline = ''
          set days (if set --query $argv[1]; echo $argv[1]; else; echo 0; end)
          vim ~/obsidian/Personal/Timeline/(date +%Y-%m-%d --date "$days days ago").md
        '';
      };
      loginShellInit = ''sway'';
    };

    programs.starship.enable = true;

    programs.alacritty = {
      enable = true;

      # https://github.com/alacritty/alacritty/blob/v0.11.0/alacritty.yml
      settings = {
        window.padding = { x = 10; y = 10; };
        window.opacity = 0.95;
        font = rec {
          normal.family = "FiraCode Nerd font";
          normal.style = "Regular";

          bold.family = normal.family;
          bold.style = "Bold";

          italic.family = normal.family;
          italic.style = "Light";
        };
      };
    };

    programs.gh.enable = true;
    programs.git = {
      enable = true;
      userName = "Marcus Whybrow";
      userEmail = "marcus@whybrow.uk";
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-fish
        vim-nix

        # Docs for install Vim/NeoVim packages with Nix
        # https://github.com/NixOS/nixpkgs/blob/b740337fb5b41e893d456e3b6cd5b62b6dad5098/doc/languages-frameworks/vim.section.md

        # https://github.com/xiyaowong/transparent.nvim
        (pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "transparent.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "xiyaowong";
            repo = "transparent.nvim";
            rev = "2d8d650fc8a3b8da6a01031295547295eb473b7d";
            hash = "sha256-6NmVgXlA7Afwwf+XEXJRAp1LIvaFTEQbxg1u1Hqoq1A=";
          };
        })
      ];
    };
    
    programs.rofi.enable = true;

    programs.waybar = let
      alacritty = "${pkgs.alacritty}/bin/alacritty";
    in {
      enable = true;
      marcusBar = {
        enable = true;
        network.onClick = ''${pkgs.networking}/bin/networking'';
        cpu.onClick =     ''${alacritty} -e htop --sort-key=PERCENT_CPU'';
        memory.onClick =  ''${alacritty} -e htop --sort-key=PERCENT_MEM'';
        disk.onClick =    ''${alacritty} -e htop --sort-key=IO_RATE'';
        date.onClick =    ''${pkgs.xdg-utils}/bin/xdg-open https://calendar.proton.me/u/1'';
        colors.primary = "1e88eb";
      };
    };

    programs.toggle.enable = true;
    wayland.windowManager.sway = let
      modifier = "Mod1";
    in {
      enable = true;

      config = {
        inherit modifier;
        bars = [];
        terminal = "alacritty";
        menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons -i -display-drun Launch";

        input."*" = {
          repeat_delay = "300";
          xkb_layout = "gb";
          natural_scroll = "enabled";
          tap = "enabled";
        };

        output."*".background = ''~/Downloads/wallpaper-seafoam.jpg fill'';

        gaps = {
          smartBorders = "off";
          smartGaps = false;
          inner = 10;
        };

        keybindings = lib.mkOptionDefault {
          "${modifier}+Escape" = ''exec ${pkgs.logout}/bin/logout'';
          "${modifier}+Shift+Escape" = ''exec ${pkgs.toggle}/bin/toggle waybar'';
          XF86AudioMute = ''exec ${pkgs.volume}/bin/volume toggle-mute'';
          XF86AudioLowerVolume = ''exec ${pkgs.volume}/bin/volume down'';
          XF86AudioRaiseVolume = ''exec ${pkgs.volume}/bin/volume up'';
          # XF86AudioPrev = ''exec'';
          # XF86AudioPlay = ''exec'';
          # XF86AudioNext = ''exec'';
          XF86MonBrightnessUp = ''exec ${pkgs.brightness}/bin/brightness up'';
          XF86MonBrightnessDown = ''exec ${pkgs.brightness}/bin/brightness down'';
        };
      };

      # Ordinarily waybar would lauch itself, but you can't do that if you want
      # to use "hide" mode so it appears only when holding the Sway modifier key.
      # https://github.com/Alexays/Waybar/wiki/Configuration
      # https://github.com/Alexays/Waybar/pull/1244
      extraConfig = ''
        bar {
          swaybar_command waybar
          mode hide
          hidden_state hide
          modifier ${modifier}
        }
      '';
    };
  };
}
