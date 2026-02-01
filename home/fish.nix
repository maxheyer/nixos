{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellInit = ''
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.krew/bin
    '';

    shellAliases = {
      lg = "lazygit";
      k = "kubectl";
      v = "nvim";
    };

    functions = {
          envsource = {
            description = "Load .env file into fish";
            body = ''
              if test (count $argv) -eq 0
                  echo "Usage: envsource <file>"
                  return 1
              end
              if not test -f $argv[1]
                  echo "Error: File '$argv[1]' not found"
                  return 1
              end
              for line in (grep -v '^#' $argv[1] | grep -v '^$')
                  set item (string split -m 1 '=' $line)
                  if test (count $item) -eq 2
                      set -gx $item[1] $item[2]
                      echo "Exported key $item[1]"
                  end
              end
            '';
          };
          rebuild = {
            description = "Rebuild NixOS configuration for the current hostname";
            body = ''
              set host (hostname -s)
              echo "Rebuilding NixOS for host: $host"
              if not test -d ~/nixos
                  echo "Error: ~/nixos directory not found"
                  return 1
              end
              pushd ~/nixos > /dev/null; or return 1
              sudo nixos-rebuild switch --flake ".#$host"
              set result $status
              popd > /dev/null
              return $result
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
    settings = {
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf.enable = true;
}
