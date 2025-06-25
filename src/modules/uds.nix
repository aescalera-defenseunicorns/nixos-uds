{
  pkgs,
  customPkgs,
  ...
}: let
  udsBundle = ../uds-bundle.tar.zst;
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
