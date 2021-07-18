{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems."/" = {
        device = "root";
        fsType = "tmpfs";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
    };

    fileSystems."/linger" = {
        device = "/dev/disk/by-label/linger";
        fsType = "xfs";
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-label/nix";
        fsType = "xfs";
    };
}
