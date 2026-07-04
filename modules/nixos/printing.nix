{ pkgs, ... }: {
  services.printing = {
    enable = true;

    drivers = with pkgs; [
      gutenprint
      hplip
    ];

    browsing = true;

    browsedConf = ''
      BrowseRemoteProtocols dnssd
      BrowseLocalProtocols dnssd
      CreateIPPPrinterQueues All
    '';
  };
}
