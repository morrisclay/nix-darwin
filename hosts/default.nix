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
    flox.packages.aarch64-darwin.default
  ];

  # Homebrew for GUI apps and taps
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "charmbracelet/tap"
    ];
    brews = [
      "charmbracelet/tap/crush"
      "node@22"
      "nvm"
      "snowflake-cli"
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

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.nix-daemon.enable = true;

  # Set system state version
  system.stateVersion = 6;
}
