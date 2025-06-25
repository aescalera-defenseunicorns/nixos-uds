{ customPkgs, ... }: {

  system.stateVersion = "25.11";
  nixpkgs.pkgs = customPkgs;
}
