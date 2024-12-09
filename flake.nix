{
  description = "CylisOS";

  inputs = {
    jerry.url = "github:justchokingaround/jerry";
    nyaa = {
      url = "github:Beastwick18/nyaa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    ghostty.inputs.nixpkgs-stable.follows = "nixpkgs";
    ghostty.inputs.nixpkgs-unstable.follows = "nixpkgs";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen.url = "github:MarceColl/zen-browser-flake";
    pollymc = {
      url = "github:fn2006/PollyMC";
    };
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    niri.url = "github:sodiboo/niri-flake";
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # base16.url = "github:SenchoPens/base16.nix";
    # This is required for plugin support.
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-stable,
      ghostty,
      spicetify-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "dragneel";
      username = "cylis";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  inputs.niri.overlays.niri
                ];
                environment.systemPackages = [
                  ghostty.packages.x86_64-linux.default
                  inputs.zen.packages.x86_64-linux.default
                  pkgs.niri-unstable
                  inputs.umu.packages.${pkgs.system}.umu
                ];
              }
            )
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./hosts/${host}/home.nix
          inputs.stylix.homeManagerModules.stylix
        ];
        extraSpecialArgs = {
          inherit
            inputs
            username
            host
            spicetify-nix
            ;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
    };
}
