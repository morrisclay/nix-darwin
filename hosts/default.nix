{ pkgs, flox, ... }: {
  nixpkgs.config.allowUnfree = true;

  # System packages (CLI tools)
  environment.systemPackages = with pkgs; [
    gh
    cloudflared
    tailscale
    tmux
    claude-code
    gemini-cli
    uv
    zig
    bun
    nodejs_22
    flox.packages.aarch64-darwin.default

    # Modern CLI tools
    jq
    ripgrep
    fd
    fzf
    bat
    eza
    delta
  ];

  # Homebrew for GUI apps and taps
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "charmbracelet/tap"
      "cirruslabs/cli"
    ];
    brews = [
      "charmbracelet/tap/crush"
      "snowflake-cli"
      "cirruslabs/cli/tart"
    ];
    casks = [
      "ghostty"
      "orbstack"
      "superwhisper"
      "zed"
    ];
  };

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Let Determinate Nix manage the daemon; disable nix-darwin's nix management
  nix.enable = false;

  # Set system state version
  system.stateVersion = 6;
}
