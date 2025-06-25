{
  basepkgs,
  forkpkgs,
  ...
} : let
  udsbundle = ../uds-bundle.tar.zst;
in {
  environment.systemPackages = with basepkgs; [forkpkgs.uds];
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${forkpkgs.uds}/bin/uds-cli deploy ${udsbundle} --confirm";
  };
}
