.PHONY: switch update check chopshop bootstrap auth clt flox test dry-run backup

clt:
	@if ! xcode-select -p &>/dev/null; then \
		echo "Installing Command Line Tools..."; \
		sudo xcode-select --install; \
		echo "Waiting for CLT installation to complete..."; \
		until xcode-select -p &>/dev/null; do sleep 5; done; \
	else \
		echo "CLT installed at $$(xcode-select -p)"; \
	fi
	@echo "Accepting Xcode license..."
	@sudo xcodebuild -license accept 2>/dev/null || true

dry-run:
	darwin-rebuild build --flake .#morris-mac
	@echo ""
	@echo "==> System packages that would be installed:"
	@nix store diff-closures /nix/var/nix/profiles/system ./result 2>/dev/null || true
	@echo ""
	@echo "==> Brew packages that would be REMOVED (not in config):"
	@comm -23 <(brew leaves 2>/dev/null | sort) <(echo "charmbracelet/tap/crush\nsnowflake-cli\ncirruslabs/cli/tart" | sort) || true
	@echo ""
	@echo "==> Brew casks that would be REMOVED (not in config):"
	@comm -23 <(brew list --cask 2>/dev/null | sort) <(echo "ghostty\norbstack\nsuperwhisper\nzed" | sort) || true
	@echo ""
	@echo "==> Files that would be overwritten:"
	@for f in ~/.zshrc ~/.gitconfig ~/.ssh/config ~/.config/zed/settings.json; do \
		[ -f "$$f" ] && echo "  $$f"; \
	done; true
	@rm -f result

backup:
	@mkdir -p ~/.dotfiles-backup
	@for f in ~/.zshrc ~/.gitconfig ~/.ssh/config ~/.config/zed/settings.json; do \
		[ -f "$$f" ] && cp "$$f" ~/.dotfiles-backup/$$(basename "$$f").bak && echo "Backed up $$f"; \
	done; true
	@echo "Backups saved to ~/.dotfiles-backup/"

switch:
	darwin-rebuild switch --flake .#morris-mac

update:
	nix flake update
	darwin-rebuild switch --flake .#morris-mac

check:
	nix flake check

auth:
	gh auth status || gh auth login

flox:
	@command -v flox &>/dev/null && echo "Flox already installed" || \
		curl -fsSL https://downloads.flox.dev/by-env/stable/osx/flox-latest.pkg -o /tmp/flox.pkg && \
		sudo installer -pkg /tmp/flox.pkg -target / && \
		rm -f /tmp/flox.pkg

chopshop:
	curl -fsSL https://raw.githubusercontent.com/Lunar-VC/ChopShop/main/install.sh | bash

bootstrap: clt switch auth flox chopshop

test:
	./scripts/test-bootstrap.sh
