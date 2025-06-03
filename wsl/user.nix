{ config, pkgs, ... }:
{
  imports = [
    # ./users
    # ../common/sudo.nix
  ];
  users.defaultUserShell = pkgs.zsh;
  users.users.antares = {
    isNormalUser = true;
    home = "/home/antares";
    description = "Antares0982";
    extraGroups = [
      "wheel"
    ];
    uid = 1000;
    useDefaultShell = true;
  };
  wsl.defaultUser = "antares";
}
