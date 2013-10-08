{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];
  boot.initrd.luks.devices = [
    { name = "cryptfs"; device = "/dev/sda3"; }
  ];
  boot.initrd.luks.cryptoModules = [ "aes" "sha256" "sha1" "xts" ];
  boot.initrd.postMountCommands = "cryptsetup luksOpen --key-file /mnt-root/root/.swapkey /dev/sda2 cryptswap";
  boot.initrd.kernelModules = [ "uhci_hcd" "ehci_hcd" "ahci" "firewire_ohci" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_3_10;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    version = 2;
  };
  fileSystems = [
  { 
    mountPoint = "/";
    device = "/dev/mapper/cryptfs";
    fsType = "ext4"; 
  }
  { 
    mountPoint = "/boot";
    device = "/dev/sda1";
    fsType = "ext2"; 
  }
  ];

  environment.systemPackages = with pkgs; [
    emacs24
    texLive
  ];
  
  nix.maxJobs = 2;
}
