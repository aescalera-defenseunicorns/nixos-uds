{
  basepkgs,
  forkpkgs,
  ...
}: let
  # Build the UDS bundle tarball
  udsBundle = forkpkgs.runCommandLocal "uds-bundle" {} ''
    mkdir -p $out
    cp ${./uds-bundle.yaml} $out/uds-bundle.yaml
    ${forkpkgs.uds}/bin/uds create $out/uds-bundle.yaml --confirm --output $out/uds-bundle.tar.zst
  '';
in {
  system.stateVersion = "25.11";
  services.k3s.enable = true;
  environment.systemPackages = with basepkgs; [forkpkgs.uds];
  environment.etc."uds-bundle.tar.zst".source = udsBundle;
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${forkpkgs.uds}/bin/uds deploy /etc/uds-bundle.tar.zst";
  };
}
