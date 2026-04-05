{ self, inputs, ... }: {
  flake.nixosConfigurations.asus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.asusConfiguration
    ];
  };
}
