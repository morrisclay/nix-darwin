{ pkgs, ... }: {
  home.stateVersion = "24.11";

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      lt = "eza --tree";
      cat = "bat --paging=never";
    };
    initExtra = ''
      # OpenClaw Completion
      source <(openclaw completion --shell zsh)

      # Google Cloud SDK
      if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
      if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
    '';
  };

  programs.git = {
    enable = true;
    userName = "morris clay";
    userEmail = "morrisclay@gmail.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    includes = [ "~/.orbstack/ssh/config" ];
  };

  # Zed settings
  home.file.".config/zed/settings.json".text = builtins.toJSON {
    telemetry = {
      diagnostics = false;
      metrics = false;
    };
    session = {
      trust_all_worktrees = true;
    };
    vim_mode = true;
    base_keymap = "VSCode";
    ui_font_size = 16;
    buffer_font_size = 15;
    theme = {
      mode = "system";
      light = "Ayu Light";
      dark = "Ayu Dark";
    };
  };
}
