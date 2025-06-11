{
  pkgs,
  udsBundle,
  ...
}: {
  services.k3s.enable = true;
  environment.systemPackages = with pkgs; [uds];
  environment.etc."uds-bundle.tar.zst".source = udsBundle;
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.uds}/bin/uds deploy /etc/uds-bundle.tar.zst";
  };
}
