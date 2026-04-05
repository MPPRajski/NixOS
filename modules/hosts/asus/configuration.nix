{ self, inputs, ... }: {
  flake.nixosModules.asusConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.asusHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    nixpkgs.config.allowUnfree = true;

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # Remove these three if lspci shows no Nvidia GPU
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;
    hardware.nvidia.powerManagement.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.mike = {
      isNormalUser = true;
      description = "Mike Ray";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        neovim
        keyd
        ghostty
        git
        ungoogled-chromium
        zed-editor
        gcc
        luarocks
        lua5_1
        python315
        ripgrep   # rg
        fd
        lazygit
        fzf
        unzip
        wget
        nautilus
        fuzzel
        swaylock
        playerctl
        brightnessctl
      ];
    };


    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    environment.systemPackages = with pkgs; [
      (vimPlugins.nvim-treesitter.withPlugins (p: with p; [
        nix lua python bash c vim vimdoc markdown markdown_inline 
      ]))
    ];

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
            otherlayer = {};
          };
        };
      };
    };

    system.stateVersion = "25.11";
  };
}
