#!/usr/bin/env bash
set -e

if [ "$USER" != "root" ]; then
  echo "🔒 Using sudo" >&2
  sudo=$(which sudo)
  $sudo echo "🔓 Checking for sudo privileges ... ✅" >&2
fi

tempdir=$(mktemp -d)
trap 'rm -rf "$tempdir"' exit

echo "⬇️  Downloading files" >&2
curl --silent --fail-with-body --output "$tempdir/github-ssh-keys#1" \
  --write-out '%{stderr}  - %{method} %{url} %{http_code} (%header{etag})\n'\
  'https://jmanero.github.io/github-ssh-keys/github-ssh-keys{,@.service,@.timer}'

echo "⬇️  Successfully downloaded all files ... ✅" >&2

echo "🔨 Installing files in /usr/local/bin" >&2
$sudo chmod 755 "$tempdir/github-ssh-keys"
$sudo mv "$tempdir/github-ssh-keys" /usr/local/bin/
$sudo restorecon /usr/local/bin/github-ssh-keys

if [ -d /etc/systemd/system ]; then
  echo "🔨 Installing units in /etc/systemd/system" >&2
  $sudo chown root:root "$tempdir/github-ssh-keys@.service" "$tempdir/github-ssh-keys@.timer"
  $sudo chmod 0644 "$tempdir/github-ssh-keys@.service" "$tempdir/github-ssh-keys@.timer"

  $sudo mv "$tempdir/github-ssh-keys@.service" /etc/systemd/system
  $sudo mv "$tempdir/github-ssh-keys@.timer" /etc/systemd/system
  $sudo restorecon /etc/systemd/system/github-ssh-keys@.service /etc/systemd/system/github-ssh-keys@.timer

  $sudo systemctl daemon-reload
fi

echo "✅ All done. 👍 GREAT SUCCESS 👍" >&2

if [ -d /etc/systemd/system ]; then
  cat >&2 <<-MESSAGE

  +-------------------------------------------------------------------------------+
  | Enable systemd units to check for updates periodically:                       |
  |                                                                               |
  |   sudo systemctl enable --now github-ssh-keys@USER.timer                      |
  |   sudo systemctl enable --now github-ssh-keys@USER.service                    |
  +--------------------------------------------------------------------------------
MESSAGE
fi
