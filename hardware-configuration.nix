# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  config = {
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/f2c169f6-3083-442a-bd62-e17940cf6ca2";
        fsType = "ext4";
      };

    boot.initrd.luks.devices."luks-af00d292-041b-492b-b3a0-a710f0ed2d2c".device = "/dev/disk/by-uuid/af00d292-041b-492b-b3a0-a710f0ed2d2c";

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/0FD3-A11C";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/b505b308-5b19-4666-8da9-297678d13b09"; }
      ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp0s12f0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  };
}
