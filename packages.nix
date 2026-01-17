{
  config,
  lib,
  pkgs,
  pull-all,
  renewal,
  ...
}:
{
  imports = [ ./kde.nix ];
  environment.systemPackages = with pkgs; [
    android-tools
    aria2
    cheat
    direnv
    imagemagick
    kdePackages.kdeconnect-kde
    libnotify
    nixfmt-rfc-style
    perf
    pull-all
    qbittorrent
    renewal
    steam-run
    telegram-desktop
    thunderbird
    tor-browser
    xorg.xeyes
    ydotool
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];

  # below are fake to make `nix flake check` happy.
  system.stateVersion = "24.11";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ebf4976f-e437-4ab5-8dcc-36af94abf096";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ebf4976f-e437-4ab5-8dcc-36af94abf096";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ebf4976f-e437-4ab5-8dcc-36af94abf096";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AA4D-DE52";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/74882867-f928-4271-bcea-fdf5fc5cbe5f"; } ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        extraEntries = ''
          menuentry 'Windows Boot Manager (on /dev/nvme0n1p2)' --class windows --class os $menuentry_id_option 'AA4D-DE52' {
            insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root AA4D-DE52
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      timeout = 10;
    };
    blacklistedKernelModules = [ "nouveau" ];
    initrd.kernelModules = [ ];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_zen);
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-intel"
      "nvidia_drm"
    ];
    extraModulePackages = [
    ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  nixpkgs.config.allowUnfree = true;
}
