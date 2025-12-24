{inputs, outputs, pkgs, lib, config, ...}:
let
  inherit (lib) concatStringsSep;
  rsyncSSHKeys = config.users.users.mattr-.openssh.authorizedKeys.keys;
  jre8 = pkgs.temurin-bin-8;
  jre17 = pkgs.temurin-bin-17;
  jre21 = pkgs.temurin-bin;

  jvmOpts = concatStringsSep " " [
    "-XX:+UseG1GC"
    "-XX:+ParallelRefProcEnabled"
    "-XX:MaxGCPauseMillis=200"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+DisableExplicitGC"
    "-XX:+AlwaysPreTouch"
    "-XX:G1NewSizePercent=40"
    "-XX:G1MaxNewSizePercent=50"
    "-XX:G1HeapRegionSize=16M"
    "-XX:G1ReservePercent=15"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MixedGCCountTarget=4"
    "-XX:InitiatingHeapOccupancyPercent=20"
    "-XX:G1MixedGCLiveThresholdPercent=90"
    "-XX:G1RSetUpdatingPauseTimePercent=5"
    "-XX:SurvivorRatio=32"
    "-XX:+PerfDisableSharedMem"
    "-XX:MaxTenuringThreshold=1"
    "-Dfml.readTimeout=120"
  ];

  serverDefaults = {
    white-list = false;
    max-tick-time = 5 * 60 * 1000;
  };
in {
  imports = [inputs.minecraft-servers.module];

  networking.hostName = "teevee";

  # Use NetworkManager for networking
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services = {
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };

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

  services.tailscale = {
    enable = true;
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

  services.modded-minecraft-servers = {
    eula = true;
    instances = {
      atm10 = {
        enable = true;
        inherit rsyncSSHKeys jvmOpts;
        jvmMaxAllocation = "16G";
        jvmInitialAllocation = "4G";
        jvmPackage = jre21;
        serverConfig =
          serverDefaults
          // {
            server-port = 25565;
            rcon-port = 25566;
            motd = "Welcome to ATM 10!";
            allow-flight = true;
            pvp = false;
            extra-options.difficulty = "hard";
            extra-options.gamemode = "survival";
        };
      };

      atm10tts = {
        enable = true;
        inherit rsyncSSHKeys jvmOpts;
        jvmMaxAllocation = "16G";
        jvmInitialAllocation = "4G";
        jvmPackage = jre21;
        serverConfig =
          serverDefaults
          // {
            server-port = 25567;
            rcon-port = 25568;
            motd = "Welcome to ATM 10 - To The Sky!";
            allow-flight = true;
            pvp = false;
            extra-options.level-type = "skyblockbuilder:skyblock";
            extra-options.difficulty = "hard";
            extra-options.gamemode = "survival";
        };
      };
    };
  };
}
