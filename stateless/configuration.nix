{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ]

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "England/London";
    i18n.defaultLocale = "en_US.UTF-8";

    networking.hostName = "stateless";
    networking.interfaces.enp1s0.useDHCP = true;
    # networking.wireless.enable = true;
    networking.useDHCP = false;  # this is deprecated so we set to false

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowedUDPPorts = [];

    services.openssh.enable = true;

    users.users.operator = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };

    environment.systemPackages = with pkgs; [
        vim
        wget
    ]
}
