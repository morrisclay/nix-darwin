{
  description = "Morris's Mac system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flox.url = "github:flox/flox/latest";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, flox, ... }: {
    darwinConfigurations."morris-mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit flox; };
      modules = [
        ./hosts/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.morris = import ./home/default.nix;
        }
      ];
    };
  };
}
