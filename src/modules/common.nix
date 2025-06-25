{...}: {
  system.stateVersion = "25.11";
  users.users.root.initialHashedPassword = "$2b$05$t8dCcckWBnZil0uWd5eoROJc2dNSrcGYjU8yE9.N2/DAgJXlY0h0W"; # changeme

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

}
