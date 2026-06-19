{
    description = "Snippy Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs }: 
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        baseDeps = with pkgs; [ rofi fzf jq gettext perl ];

        buildPackage = { x11, wayland }:
        let
            deps = baseDeps ++ (
                with pkgs; 
                if wayland then [ wtype wl-clipboard ] 
                else [ xdotool xclip xsel ] 
            );
        in
        pkgs.stdenv.mkDerivation {
            pname = "snippy";
            version = "git";

            nativeBuildInputs = [ pkgs.makeWrapper ];
          
            src = ./.;

            installPhase = ''
                mkdir -p $out/bin
                cp snippy $out/bin

                wrapProgram $out/bin/snippy\
                  --prefix PATH : ${pkgs.lib.makeBinPath deps}
            '';
        };
    in
    {
        packages.${system} = {
            default = buildPackage { x11 = false; wayland = true ; };
            wayland = buildPackage { x11 = false; wayland = true ; };
            x11     = buildPackage { x11 = true ; wayland = false; };
        };
    };
}
