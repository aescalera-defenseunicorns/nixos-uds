{
  pkgs,
  customPkgs,
  ...
}: let
  # udsBundle = pkgs.runCommandLocal "uds-bundle.tar.zst" {} ''
  #   cp ${/tmp/uds-bundle-nixos-amd64-0.0.1.tar.zst} $out
  # '';
  udsBundleDir = /tmp/uds-bundle-nixos;
in {
  nixpkgs.pkgs = customPkgs;
  environment.systemPackages = with pkgs; [uds];
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    environment = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };
    serviceConfig.ExecStart = "${pkgs.uds}/bin/uds-cli deploy ${udsBundleDir}/uds-bundle-nixos-amd64-0.0.1.tar.zst --confirm";
  };
}
