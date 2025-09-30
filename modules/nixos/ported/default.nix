{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  lock-false = { Value = false ; Status = "locked"; };
  lock-true = { Value = true; Status = "locked"; };
  lock-empty-string = { Value = ""; Status = "locked"; };
in
{

  # Allow microcode updates for CPUs
  hardware.enableRedistributableFirmware = true;

  # Default locale settings which can be overridden on a per system
  # basis
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };
  time.timeZone = lib.mkDefault "America/Chicago";

  # Configure sudo
  security.sudo = {
    enable = true;
    keepTerminfo = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  # Provide vim, curl, and git on every linux system
  # because I use these all the time.
  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    ghostty.terminfo
    steam-devices-udev-rules
    spotify
    discord
    mangohud
    obsidian
  ];

  boot.kernel.sysctl = {
    # Sysctl customizations from steamos
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    # Lower the fin timeout to let games reuse their ports
    # if they're killed and restarted too quickly
    "net.ivp4.tcp_fin_timeout" = 5;
    # Prevents slowdowns in case games experience split locks
    "kernel.split_lock_mitigate" = 0;

    "vm.max_map_count" = 2147483642;

    # security tweaks borrowed from @hlissner
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };

  boot.kernelModules = ["tcp_bbr"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
      mesa
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
    ];
  };

  systemd.user.services.telephony_client.enable = false;

  services.pipewire = {
    wireplumber = {
      enable = true;
      configPackages = [
        # Improve the sound quality for BT headphones
        # Check https://wiki.gentoo.org/wiki/User:Nathanlkoch/Tutorials/Audio
        # for additional improvements to make
        (pkgs.writeTextDir "share/bluetooth.lua.d/51-bluez-config.lua" ''
          bluez_monitor.properties = {
            ["bluez5.enable-sbc-xq"] = true,
            ["bluez5.enable-msbc"] = true,
            ["bluez5.enable-hw-volume"] = true,
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
            ["bluez5.a2dp.ldac.quality"] = "auto",
            ["bluez5.a2dp.aac.bitratemode"] = 0,
            ["bluez5.default.rate"] = 48000,
            ["bluez5.default.channels"] = 2,
            ["bluez5.headset-profile"] = "a2dp-only"  # A2DP for better quality
          }
        '')
      ];
      extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";
    };
  };
  services.fwupd.enable = true;

  # network discovery, mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  services.tailscale = {
    enable = true;
  };

  services.flatpak.enable = true;

  # services.greetd = let
  #   tuigreet_session = {
  #     command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --container-padding 2 --no-xsession-wrapper --cmd Hyprland";
  #     user = "greeter";
  #   };
  #   niri_session = {
  #     command = "${pkgs.niri}/bin/niri-session";
  #     user = "mattr-";
  #   };
  #   gtkgreet_session = {
  #     command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
  #     user = "greeter";
  #   };
  # in
  # {
  #   enable = true;
  #   settings = {
  #     default_session = tuigreet_session;
  #     initial_session = tuigreet_session;
  #   };
  # };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/

  # systemd = {
  #   # To prevent getting stuck at shutdown
  #   extraConfig = "DefaultTimeoutStopSec=10s";
  #   services.greetd.serviceConfig = {
  #     Type = "idle";
  #     StandardInput = "tty";
  #     StandardOutput = "tty";
  #     StandardError = "journal";
  #     TTYReset = true;
  #     TTYVHangup = true;
  #     TTYVTDisallocate = true;
  #   };
  # };

  powerManagement = {
    enable = true;
  };

  services = {
    logind = {
      settings = {
        Login = {
          HandleLidSwitchExternalPower = "suspend";
          HandlePowerKey = "suspend";
          HandleLidSwitch = "suspend";
        };
      };
    };

    power-profiles-daemon.enable = true;

    # battery info
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 5;
      criticalPowerAction = "Hibernate";
    };
  };

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        # No root logins
        PermitRootLogin = "no";
        # Key based logins only
        PasswordAuthentication = false;
      };
    };
  };

  programs.ssh.startAgent = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  fonts = {
    packages = with pkgs; [
      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # nerdfonts
      nerd-fonts.symbols-only

      # fancy UI fonts for things
      material-symbols
      inter
      fira-code
    ];

    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Sans CJK"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK"
          "Symbols Nerd Font Mono"
        ];
        monospace = [
          "Noto Sans Mono"
          "Noto Sans CJK"
          "Symbols Nerd Font Mono"
        ];
        emoji = [
          "Noto Color Emoji"
          "Symbols Nerd Font Mono"
        ];
      };
    };
    fontDir = {
      enable = true;
    };
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
          global = {
            overload_tap_timeout = 250;
          };
        };
      };
    };
  };

  programs.nix-ld.enable = true;
}
