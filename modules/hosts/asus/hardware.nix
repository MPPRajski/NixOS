{ self, inputs, ... }: {
	flake.nixosModules.asusHardware = { config, lib, pkgs, modulesPath, ... }:

	{
		imports =
			[ (modulesPath + "/installer/scan/not-detected.nix")
			];

		boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ "kvm-intel" ];
		boot.extraModulePackages = [ ];

		fileSystems."/" =
		{ device = "/dev/disk/by-uuid/563115b0-2502-4fde-9282-65773afc964d";
			fsType = "ext4";
		};

		fileSystems."/boot" =
		{ device = "/dev/disk/by-uuid/A9BE-F1C2";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};

		swapDevices =
			[ { device = "/dev/disk/by-uuid/959b736c-0d25-41c2-adeb-cc90d82223ca"; }
			];

			nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
			hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	};
}
