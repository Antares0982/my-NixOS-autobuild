{
  config,
  pkgs,
  lib,
  ...
}:

{
  wsl.enable = true;
  nixpkgs.config.allowUnfree = true;
  imports =
    [

      ./network.nix
      ./packages.nix
      ./user.nix
    ]
    ++ [
      # ../common/env.nix
      # ../common/nix.nix
      # ../common/nix-zshell.nix
      # ../common/sudo.nix
      # ../common/time.nix
      # ../common/zsh.nix
    ];
  system.stateVersion = "25.05";

  #
  security.sudo =
    {
      wheelNeedsPassword = false;
    }
    // (lib.optionalAttrs true {
      extraConfig = ''
        Defaults env_keep += "http_proxy https_proxy"
      '';
    });

  environment.variables = lib.attrsets.optionalAttrs true {
    http_proxy = "http://127.0.0.1:1081";
    https_proxy = "http://127.0.0.1:1081";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      extra-platforms = config.boot.binfmt.emulatedSystems;
      trusted-users = [
        "root"
        "antares"
      ];
    };
    gc = {
      dates = "weekly";
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
  systemd.services.nix-daemon.environment = lib.attrsets.optionalAttrs true {
    http_proxy = "http://127.0.0.1:1081";
    https_proxy = "http://127.0.0.1:1081";
  };
  time.timeZone = "Asia/Shanghai";
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
      ];
    };
    promptInit = "POWERLEVEL10K_MODE=nerdfont-complete source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };
}
