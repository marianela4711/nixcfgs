{ config, pkgs, ... }:

{

  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    initrd = {
      kernelModules = [ "uhci_hcd" "ehci_hcd" "ahci" "usb_storage" ];
      luks = {
        devices = [
          { name = "cryptfs"; device = "/dev/sda3"; }
        ];
        cryptoModules = [ "aes" "sha256" "sha1" "xts" ];
      };
      postMountCommands = "cryptsetup luksOpen --key-file /mnt-root/root/.swapkey /dev/sda2 cryptswap";
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_3_10;
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      version = 2;
    };
  };

  fileSystems = {

    "/" = { 
      device = "/dev/mapper/cryptfs";
      fsType = "ext4"; 
    };

    "/boot" = { 
      device = "/dev/sda1";
      fsType = "ext2"; 
    };
  
  };

  swapDevices = [
    { device = "/dev/mapper/cryptswap"; }
  ];

  networking = {
    hostName = "helium";
    interfaceMonitor.enable = true;
    wireless.enable = true;
    wireless.interfaces = [ "wlan0" ];
    wireless.userControlled.enable = true;
  };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "sv-latin1";
    defaultLocale = "en_US.UTF-8";
  }; 

  users = {
    extraUsers = [ 
    {
      createHome = true; 
      name = "nela";
      uid = 1000;
      group = "nela";
      extraGroups = [ "users" "wheel" ];
      description = "Marianela Garcia Lozano";
      home = "/home/nela";
      useDefaultShell = true; 
    }
    ];

   extraGroups = [
    { 
      name = "nela";
      gid = 1000; 
    }
    ];
  };

  environment = {
    nix = pkgs.nixUnstable;
    systemPackages = with pkgs; [
      acpi
      cups
      curl
      emacs24
      fuse
      gitAndTools.gitFull
      gnupg
      inetutils
      iptables
      openjdk
      openssh
      openvpn
      p7zip
      pv
      python
      screen
      sshfsFuse
      strace
      sudo
      tsocks
      unison
      vlc
      wpa_supplicant
      texLive
    ];

    x11Packages = with pkgs; [
      emacs24 
      firefoxWrapper
      gimp
      #gnome.gnometerminal
      #gnome.GConf
      #gnome.gconfeditor
      inkscape
      keepassx
      libreoffice
      mplayer
      mupdf
      rdesktop
      rxvt_unicode
      wpa_supplicant_gui
      xlockmore
      xournal
      xscreensaver
   ];
  };

  time.timeZone = "Europe/Stockholm";

  services = {
    dbus.packages = with pkgs; [ gnome.GConf ];
    nixosManual.showManual = true;
    openssh.enable = true;
    printing.enable = true;
    xserver = {
      enable = true;
      autorun = true;
      layout = "se";
      desktopManager.xfce.enable = true;
      #displayManager.lightdm.enable = true;
      xkbModel = "pc105";
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
  };
  
  nixpkgs.config = {
    firefox = {
      enableAdobeFlash = true;
      enableDjvu = true;
      enableFriBIDPlugin = true;
    };
    rxvt_unicode = {
      perlBindings = true;
    };
  };
 
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    extraFonts = [
      pkgs.corefonts
      pkgs.vistafonts
    ];
  };
  
  programs.bash.enableCompletion = true;

  powerManagement.enable = true;

  nix = {
    # proxy = "http://www-gw.foi.se:8080";
    maxJobs = 2;
    useChroot = true;
  };
}
