{ pkgs, lib, ... }:

{
  dotenv.enable = true;

  git-hooks.hooks.acm = {
    enable = true;
    entry = lib.getExe pkgs.acm;
    stages = [ "prepare-commit-msg" ];
  };

  cachix.pull = [ "sestrella" ];
}
