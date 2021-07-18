{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ]

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


    # ===============
    # USER MANAGEMENT
    # ===============

    users.mutableUsers = false;
    users.users.root.hashedPassword = "disabled";

    users.users.operator = {
        home = "/home/operator";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPSYQ1YyGabCnHTKVYgBxnAhalznCHIpg1V6/Wo5dBS" ];
    };


    # ==================
    # PACKAGE MANAGEMENT
    # ==================

    environment.systemPackages = with pkgs; [
        vim
        wget
    ]
}
