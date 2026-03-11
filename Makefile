.PHONY: switch update check chopshop bootstrap auth clt flox test

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
