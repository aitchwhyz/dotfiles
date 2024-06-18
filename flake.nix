{
  description = "flakes for aitchwhyz";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    # nil.url = "github:oxalica/nil";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, flake-utils }:
  let
    configuration = { pkgs, ... }: {
      # # List packages installed in system profile. To search by name, run:
      # # $ nix-env -qaP | grep wget
      # environment.systemPackages =
      #   [ pkgs.vim
      #   ];

      # # Auto upgrade nix package and the daemon service.
      # # services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # # Necessary for using flakes on this system.
      # nix.settings.experimental-features = "nix-command flakes";

      # # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.zsh.enable = true;  # default shell on catalina
      # # programs.fish.enable = true;

      # # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;

      # # Used for backwards compatibility, please read the changelog before changing.
      # # $ darwin-rebuild changelog
      # system.stateVersion = 4;

      # # The platform the configuration will be used on.
      # nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build jk
    darwinConfigurations = {
      # hostPlatform = "aarch64-darwin";
      "aitch-mac-studio" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./darwin/darwin.nix
          home-manager.darwinModules.home-manager
          {
            _module.args = { inherit inputs; };
            home-manager = {
              users.hank = import ./home/home.nix;
            };
            users.users.hank.home = "/Users/hank";
          }
        ];
      };
    };
    # darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
    # };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}
