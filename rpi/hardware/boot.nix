{
  config,
  pkgs,
  kernelPatches,
  nix-rpi5,
  ...
}:
let
  linux_rpi5 = pkgs.callPackage ./linux-rpi.nix {
    rpiVersion = 5;
  };
in
{
  boot = {
    initrd = {
      availableKernelModules = [
        "uas"
        "usbhid"
        "usb_storage"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    kernelPackages = nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };
}
