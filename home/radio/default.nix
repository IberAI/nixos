{ pkgs, ... }: {
  home.packages = with pkgs; [
    chirp
    cubicsdr
    fldigi
    flrig
    hamlib
    rtl-sdr
    rtl_433
    wsjtx
  ];
}
