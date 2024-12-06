{
  config,
  pkgs,
  kernelPatches,
  nix-rpi5,
  ...
}:
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
