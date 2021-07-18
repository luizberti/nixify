# ==============
# DISK SELECTION
# ==============

set --local devices (lsblk --list --nodeps --noheadings --output=name,type | awk '$2 == "disk" {print $1}')

echo 'DISK DEVICES AVALIABLE:' $devices
read --local --prompt-str='Which device to install on? ' disk

if not contains $disk $devices
    echo $disk is not a valid option >&2
    exit 1
end


# ===========================
# PARTITIONING AND FORMATTING
# ===========================

# /boot
echo '================ /boot'
sudo parted --script /dev/$disk -- mktable gpt
sudo parted --script /dev/$disk -- mkpart boot fat32 1MiB 512MiB
sudo parted --script /dev/$disk -- set 1 esp on
sudo mkfs.fat -F32 -n boot /dev/{$disk}1

# /linger
echo '================ /linger'
sudo parted --script /dev/$disk -- mkpart linger xfs 512MiB 1GiB
sudo mkfs.xfs -f -L linger /dev/{$disk}2

# /nix
echo '================ /nix'
sudo parted --script /dev/$disk -- mkpart nix xfs 1GiB 12GiB
sudo mkfs.xfs -f -L nix /dev/{$disk}3


# ===================
# MOUNTS AND INSTALLS
# ===================
# TODO make more things readonly for server deployments like ContainerOS does

sudo mkdir -p /mnt
sudo mount -t tmpfs root /mnt

sudo mkdir -p /mnt/boot
sudo mkdir -p /mnt/linger
sudo mkdir -p /mnt/nix

sudo mount /dev/disk/by-label/boot   /mnt/boot
sudo mount /dev/disk/by-label/linger /mnt/linger
sudo mount /dev/disk/by-label/nix    /mnt/nix

sudo mkdir -p /mnt/etc/nixos/
sudo cp configuration.nix /mnt/etc/nixos/
sudo nixos-generate-config --root /mnt
sudo nixos-install --no-root-passwd --root /mnt
