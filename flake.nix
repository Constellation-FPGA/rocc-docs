{
  description = "Rocket Documentation Wiki";

  # Nixpkgs version to use
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
    let
      # System types to support.
      # This is a wiki with no real architecture dependencies
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
      {
        # Building this flake will involve building this Wiki.
        packages = {};

        # This flake does not provide any packages, so it cannot have apps
        # either.
        # apps is meant to play with the "nix run" command.
        apps = {};

        # What we really want
        devShells = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                mdbook

                # keep this line if you use bash
                bashInteractive
              ];

              # Ensure locales are present
              LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
              hardeningDisable = [ "all" ];
            };
          });
      };
}
