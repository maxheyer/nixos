{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      lg = "lazygit";
      k = "kubectl";
      v = "nvim";
    };

    functions = {
          rebuild = {
            description = "Rebuild NixOS configuration for the current hostname";
            body = ''
              set host (hostname -s)
              echo "🚀 rebuild host: $host"
              pushd ~/nixos > /dev/null
              sudo nixos-rebuild switch --flake ".#$host"
              popd > /dev/null
            '';
          };
    };

    interactiveShellInit = ''
      set fish_greeting
    '';

    plugins = [
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf.enable = true;
}
