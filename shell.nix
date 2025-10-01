{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    gtkwave
    hexedit
    iverilog
    xxd
  ];
}
