#!/bin/bash

# 📍 Where to place the final pusher script
BIN_DIR="$HOME/bin"
mkdir -p "$BIN_DIR"

# 📝 Commit messages
COMMIT_MESSAGES=(
  "go go go"
  "fixing shitaz"
  "maybe this works"
  "pls work"
  "final final really final"
  "let's try this again"
  "minor update"
  "forgot this file"
  "yolo push"
  "code bless"
)

# ✍️ Create pusher script
cat << 'EOF' > "$BIN_DIR/pusher"
#!/bin/bash

# Random commit message generator
COMMIT_MESSAGES=(
  "go go go"
  "fixing shitaz"
  "maybe this works"
  "pls work"
  "final final really final"
  "let's try this again"
  "minor update"
  "forgot this file"
  "yolo push"
  "code bless"
)

# Pick random message
MESSAGE=${COMMIT_MESSAGES[$RANDOM % ${#COMMIT_MESSAGES[@]}]}

# Run git commands
echo "🟨 git add *"
git add *

echo "🟩 git commit -am \"$MESSAGE\""
git commit -am "$MESSAGE"

echo "🚀 git push"
git push
EOF

# ✅ Make executable
chmod +x "$BIN_DIR/pusher"

# 🧪 Verify
if command -v pusher >/dev/null; then
  echo "✅ 'pusher' is already in PATH."
else
  echo "🛠️  Adding $BIN_DIR to PATH in ~/.bashrc"
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.bashrc
  source ~/.bashrc
fi

echo "✅ Installed 'pusher' in $BIN_DIR"
echo "Run with: pusher"
