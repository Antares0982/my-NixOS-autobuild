{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking = {
    hostName = "rpi5";
    wireless = {
      iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };
    };
    firewall.enable = false;
  };

  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];

  services.openssh = {
    enable = false;
  };
  system.stateVersion = "24.05";
}
