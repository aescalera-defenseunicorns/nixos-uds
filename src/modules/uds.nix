{
  pkgs,
  ...
} : let
  udsBundle = ../uds-bundle.tar.zst;
in {
  environment.systemPackages = with pkgs; [uds];
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.uds}/bin/uds-cli deploy ${udsBundle} --confirm";
  };
}
