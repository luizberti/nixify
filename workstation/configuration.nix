{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

    security.protectKernelImage = true;

    system.stateVersion = "21.05";
    system.autoUpgrade.enable = true;
    system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

    nix.gc.automatic = true;
    nix.gc.dates = "03:15";

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.cleanTmpDir = true;
    boot.tmpOnTmpfs = true;
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
        "kernel.sysrq" = 0;

        # mitigate IP spoofing with reverse path filtering
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;

        # mitigates MITM by refusing ICMP redirects
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;  # prevents logs from filling up
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;

        "net.ipv4.tcp_syncookies" = 1;  # protects against SYN floods
        "net.ipv4.tcp_rfc1337" = 1;     # somewhat protects against TIME-WAIT assassination

        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv6.tcp_fastopen" = 3;

        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv6.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
    };

    time.timeZone = "America/Sao_Paulo";
    i18n.defaultLocale = "en_US.UTF-8";


    # =======================
    # NETWORKING AND SERVICES
    # =======================

    networking.hostName = "helios";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;
    hardware.bluetooth.enable = true;

    networking.interfaces.enp1s0.useDHCP = true;
    networking.useDHCP = false;  # this is deprecated so we set to false

    networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
    networking.firewall.allowedTCPPorts = [ 22 ];     # SSH
    networking.firewall.allowedUDPPorts = [ 51820 ];  # WireGuard

    networking.wireguard.interfaces.wg0 = {
        ips = [ "100.64.0.1/10" ];
        privateKeyFile = "/linger/etc/wireguard/private.key";

        # peers = [];
    };

    services.openssh.enable = true;
    services.openssh.permitRootLogin = "no";
    services.openssh.passwordAuthentication = false;

    security.acme.acceptTerms = true;


    # ===============
    # USER MANAGEMENT
    # ===============

    users.mutableUsers = false;
    users.users.root.hashedPassword = "disabled";
    security.sudo.wheelNeedsPassword = false;

    users.users.luizberti = {
        createHome = true;
        home = "/home/luizberti";
        shell = "${pkgs.fish.out}/bin/fish";

        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];  # add "audio" if pulseaudio is enabled
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPSYQ1YyGabCnHTKVYgBxnAhalznCHIpg1V6/Wo5dBS" ];
        initialPassword = "changeme";  # TODO make this toggleable
    };


    # ==================
    # PACKAGE MANAGEMENT
    # ==================

    nixpkgs.config.allowUnfree = true;

    environment.shells = [ pkgs.fish ];
    environment.systemPackages = with pkgs; [
        dash
        fish
        starship

        git
        vim
        wget
    ];


    # ==================
    # DESKTOP MANAGEMENT
    # ==================

    fonts = {
        fontDir.enable = true;
        enableDefaultFonts = true;
        enableGhostscriptFonts = true;
        fonts = with pkgs; [ iosevka ];
    };
}
