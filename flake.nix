{
  description = "Morris's Mac system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
    let
      mkDarwin = { user, hostname }: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home/default.nix;
          }
          {
            users.users.${user}.home = "/Users/${user}";
            system.primaryUser = user;
          }
        ];
      };
    in {
      darwinConfigurations."morris-mac" = mkDarwin {
        user = "morris";
        hostname = "morris-mac";
      };

      darwinConfigurations."test" = mkDarwin {
        user = "admin";
        hostname = "test";
      };
    };
}
