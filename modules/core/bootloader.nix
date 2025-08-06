{ ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      extraEntries = ''
        menuentry "Windows" {
	  insmod part_gpt
	  insmod fat
	  insmod search_fs_uuid
	  insmod chain
	  search --fs-uuid --set=root 4480-965B
	  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
	}
      '';
    };
  };
}
