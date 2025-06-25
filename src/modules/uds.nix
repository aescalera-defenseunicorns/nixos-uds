{
  pkgs,
  ...
}: let
  # some hacky nonsense because we have to keep the uds-config.yaml and the uds-bundle-*.tar.zst outside of the git tree OR ELSE
  udsBundleDir = /tmp/uds-bundle-nixos;
in {
  environment.systemPackages = with pkgs; [uds];
  systemd.services.uds-deploy = {
    description = "Deploy UDS bundle into k3s";
    after = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    environment = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      UDS_CONFIG = "${udsBundleDir}/uds-config.yaml";
    };
    script = ''
      ${pkgs.bash}/bin/bash -l -c 'uds-cli deploy ${udsBundleDir}/*.tar.zst --confirm'
    '';
  };
}
