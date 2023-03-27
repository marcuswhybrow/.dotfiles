{ config , lib, pkgs, ... }: let
  inherit (lib) mkOption types;
  inherit (builtins) mapAttrs;
  cfg = config.custom.users;
in {
  options.custom.users = mkOption { type = with types; attrsOf (submodule {
    options = {
      fullName = mkOption { type = types.str; };
      groups = mkOption { type = with types; listOf str; };
      shell = mkOption { type = types.package; };
      packages = mkOption { type = with types; listOf package; };
      home = mkOption { type = types.attrs; default = {}; };
    };
  }); };
  config = {
    security.sudo.wheelNeedsPassword = false;
    users.users = mapAttrs (userName: userConfig: {
      isNormalUser = true;
      inherit (userConfig) shell packages;
      description = userConfig.fullName;
      initialPassword = "1234";
    }) cfg;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = (mapAttrs (userName: userConfig: userConfig.home) cfg)
        // (mapAttrs (userName: userConfig: { home.stateVersion = config.system.stateVersion; }) cfg);
      extraSpecialArgs = { inherit pkgs; };
    };
  };
}
