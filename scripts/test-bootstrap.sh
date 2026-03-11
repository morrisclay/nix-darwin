#!/bin/bash
set -euo pipefail

VM_NAME="nix-darwin-test"
BASE_IMAGE="sequoia-test"
REPO="https://github.com/morrisclay/nix-darwin.git"

echo "==> Cleaning up any previous test VM..."
tart delete "$VM_NAME" 2>/dev/null || true

echo "==> Cloning base image..."
tart clone "$BASE_IMAGE" "$VM_NAME"

echo "==> Starting VM..."
tart run "$VM_NAME" --no-graphics &
VM_PID=$!

echo "==> Waiting for VM to get an IP..."
VM_IP=""
for i in $(seq 1 60); do
  VM_IP=$(tart ip "$VM_NAME" 2>/dev/null || true)
  if [ -n "$VM_IP" ]; then break; fi
  sleep 5
done

if [ -z "$VM_IP" ]; then
  echo "ERROR: VM did not get an IP after 5 minutes"
  kill $VM_PID 2>/dev/null
  tart delete "$VM_NAME" 2>/dev/null
  exit 1
fi

echo "==> VM running at $VM_IP"

SSH="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 admin@$VM_IP"

echo "==> Waiting for SSH..."
for i in $(seq 1 30); do
  if $SSH echo "SSH ready" 2>/dev/null; then break; fi
  sleep 5
done

echo "==> Installing Nix..."
$SSH 'curl --proto "=https" --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm'

echo "==> Cloning nix-darwin config..."
$SSH ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && git clone $REPO ~/.config/nix-darwin"

echo "==> Running make switch..."
$SSH ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && cd ~/.config/nix-darwin && make switch"

echo "==> Verifying installed packages..."
$SSH ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && which gh && which tmux && which claude && which eza && which gemini"

echo ""
echo "==> Bootstrap test PASSED"

echo "==> Cleaning up..."
kill $VM_PID 2>/dev/null || true
wait $VM_PID 2>/dev/null || true
tart delete "$VM_NAME" 2>/dev/null || true
