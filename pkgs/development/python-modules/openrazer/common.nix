{ pkgs ? import <nixpkgs> {} }:
## we default to importing <nixpkgs> here, so that you can use
## a simple shell command to insert new hashes into this file
## e.g. with emacs C-u M-x shell-command
##
##     nix-prefetch-url common.nix -A src
let
  fetchFromGitHub =
    args@{
      owner,
      repo,
      rev,
      hash,
      ...
    }:
    pkgs.fetchFromGitHub {
      inherit
        owner
        repo
        rev
        hash
        ;
    }
    // args;
in rec
{
src = fetchFromGitHub rec {
  version = "3.9.0";
  owner = "openrazer";
  repo = "openrazer";
  rev = "v${version}";
  hash = "sha256-MLwhqLPWdjg1ZUZP5Sig37RgZEeHlU+DyELpyMif6iY=";
};
}
