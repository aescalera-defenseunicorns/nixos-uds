{
  pkgs,
  customPkgs,
  ...
}: let
  udsBundle = pkgs.runCommandLocal "uds-bundle.tar.zst" {} ''
    cp ${../../uds-bundle.tar.zst} $out
  '';
  # udsBundle = ../../uds-bundle.tar.zst;
in {
  nixpkgs.pkgs = customPkgs;
  environment.systemPackages = with pkgs; [uds];
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.uds}/bin/uds-cli deploy ${udsBundle} --confirm";
  };
}
