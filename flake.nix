{
  description = "NixOS workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty/v1.3.1";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ghostty,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware.nix
        ./configuration.nix
        {
          nixpkgs.overlays = [
            (final: prev: {
              ghostty = ghostty.packages.x86_64-linux.default;
              hunk = prev.stdenv.mkDerivation rec {
                pname = "hunk";
                version = "0.10.0";
                src = prev.fetchurl {
                  url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-linux-x64.tar.gz";
                  hash = "sha256-ND3Kb1u0B5O+joNCvE4LzJjYpSFnt5QWDFGmuAmYns8=";
                };
                nativeBuildInputs = [prev.patchelf];
                sourceRoot = ".";
                # Bun --compile binaries append a trailer with the bundled JS.
                # autoPatchelfHook / strip / generic ELF rewrites shift offsets
                # and corrupt the trailer, leaving plain `bun`. Only set the
                # interpreter — nothing else.
                dontStrip = true;
                dontPatchELF = true;
                installPhase = ''
                  runHook preInstall
                  install -Dm755 hunkdiff-*/hunk $out/bin/hunk
                  patchelf --set-interpreter "${prev.glibc}/lib/ld-linux-x86-64.so.2" $out/bin/hunk
                  runHook postInstall
                '';
                meta = {
                  description = "Review-first terminal diff viewer for agent-authored changesets";
                  homepage = "https://github.com/modem-dev/hunk";
                  license = prev.lib.licenses.mit;
                  mainProgram = "hunk";
                  platforms = ["x86_64-linux"];
                };
              };
            })
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.luis = ./home.nix;
        }
      ];
    };
  };
}
