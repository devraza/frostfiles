{
  fileSystems."/export/codebreaker" = {
    device = "/mnt/codebreaker";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export              100.114.54.76(rw,fsid=0,no_subtree_check)
      /export/codebreaker  100.114.54.76(rw,insecure,no_subtree_check)
    '';
  };
}
