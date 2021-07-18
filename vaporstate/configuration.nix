{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "England/London";
    i18n.defaultLocale = "en_US.UTF-8";


    # =======================
    # NETWORKING AND SERVICES
    # =======================

    networking.hostName = "stateless";
    networking.interfaces.enp1s0.useDHCP = true;
    # networking.wireless.enable = true;
    networking.useDHCP = false;  # this is deprecated so we set to false

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];     # SSH
    networking.firewall.allowedUDPPorts = [ 51820 ];  # WireGuard

    services.openssh.enable = true;
    services.openssh.permitRootLogin = "no";


    # ===============
    # USER MANAGEMENT
    # ===============

    users.mutableUsers = false;
    users.users.root.hashedPassword = "disabled";
    security.sudo.wheelNeedsPassword = false;

    users.users.operator = {
        home = "/home/operator";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];  # add "audio" if pulseaudio is enabled
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPSYQ1YyGabCnHTKVYgBxnAhalznCHIpg1V6/Wo5dBS" ];
        initialPassword = "changeme";  # TODO make this toggleable
    };


    # ==================
    # PACKAGE MANAGEMENT
    # ==================

    environment.systemPackages = with pkgs; [
        vim
        wget
    ];
}
