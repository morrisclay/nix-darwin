{ pkgs, ... }: {
  home.stateVersion = "24.11";

  programs.zsh = {
    enable = true;
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
  };

  programs.tmux = {
    enable = true;
  };
}
