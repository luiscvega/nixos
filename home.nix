{
  pkgs,
  lib,
  config,
  options,
  specialArgs,
  modulesPath,
  nixosConfig,
  osConfig,
}: {
  home.username = "luis";
  home.homeDirectory = "/home/luis";
  home.stateVersion = "24.11";

  programs.bash.enable = true;
  home.shellAliases = {
    xclip = "xclip -selection clipboard";
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    extraConfig = ''
      set number
      set nowrap
      nnoremap <C-e> :NERDTreeToggle<CR>
      colorscheme onehalfdark
    '';

    plugins = with pkgs.vimPlugins; [
      vim-go
      vim-nix
      ctrlp-vim
      nerdtree
      onehalf
      copilot-vim
    ];

    coc = {
      enable = true;
      settings = {
        languageserver = {
          golang = {
            command = "gopls";
            rootPatterns = ["go.mod"];
            filetypes = ["go"];
          };
        };
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Luis Vega";
    userEmail = "1120470+luiscvega@users.noreply.github.com";
    extraConfig.init.defaultBranch = "main";
  };

  # SSH
  programs.ssh = {
    enable = true;
    extraConfig = ''
      SetEnv TERM=xterm-256color
    '';
  };

  # direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    installVimSyntax = true;
    settings = {
      gtk-titlebar = false;
      keybind = [
        "ctrl+shift+page_down=move_tab:1"
        "ctrl+shift+page_up=move_tab:-1"
      ];
    };
  };

  programs.jq.enable = true;

  home.packages = with pkgs; [
    wget
    spotify
    tree
    bitwarden
    silver-searcher
    signal-desktop
    xclip
    alejandra
    zoom-us
  ];
}
