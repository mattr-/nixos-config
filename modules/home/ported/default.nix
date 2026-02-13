{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    gnumake
    automake
    autoconf
    gcc
    libgcc
    prismlauncher
    wezterm
    ghostty
    iosevka
    nerd-fonts.symbols-only
    hyprshot
    brightnessctl
    imagemagick
    ghostscript
    tectonic
    mermaid-cli
    anki
    quickshell
  ];

  home.sessionVariables = {
    XDG_ICON_DIR = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur";
  };

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "mattr-";
        isDefault = true;
        settings = {
          # "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.search.defaultenginename" = "ddg";
          "browser.search.order.1" = "ddg";

          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = false; # Be kind to hard drive

          # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
          # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
          # then have Firefox open on some other workspace.
          "widget.disable-workspace-management" = true;
        };
        search = {
          force = true;
          default = "ddg";
          order = [
            "ddg"
            "google"
          ];
        };
      };
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.gpg = {
    enable = true;
    # Let me manage my own keys and trust settings
    mutableKeys = true;
    mutableTrust = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-tty;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    extraConfig = "Include one_password.conf";
  };
}
