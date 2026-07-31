{
  nixpkgs ? import <nixpkgs> { },
}:
with nixpkgs;
mkShell {
  packages = with nixpkgs; [
    shellcheck
    uv
    python3
    rustup
    zizmor
    rumdl
    typos
    prek
  ];
}
