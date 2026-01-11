{
  config,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  home = {
    packages = with pkgs; [
      nodejs
      pnpm
      yarn
      deno
      watchman
    ];

    sessionVariables = {
      NPM_CONFIG_PREFIX = "${homeDir}/.npm-global";
      PNPM_HOME = "${homeDir}/.local/share/pnpm";
      YARN_GLOBAL_FOLDER = "${homeDir}/.yarn";
    };

    sessionPath = [
      "${homeDir}/.npm-global/bin"
      "${homeDir}/.local/share/pnpm"
      "${homeDir}/.yarn/bin"
      "${homeDir}/.config/yarn/global/node_modules/.bin"
    ];
  };
}
