#!/bin/bash

# Function to append "echo here" to the configuration file if not already present
append() {
	local config_file="$1"
	local command="source $kx_dir/kx.sh"

	if [[ -f "$config_file" ]]; then
		if grep -qF "$command" "$config_file"; then
			echo "Command already present in $config_file"
		else
			echo "$command" >>"$config_file"
			echo "Appended '$command' to $config_file"
		fi
	else
		echo "Configuration file $config_file not found."
	fi
}

# Create the ~/.kx directory if it doesn't exist
kx_dir="$HOME/.kx"
mkdir -p "$kx_dir"

# Download kx.sh from the GitHub repository
kx_url="https://github.com/yavrumian/kx/raw/main/kx.sh"
kx_file="$kx_dir/kx.sh"

if curl -fsSL "$kx_url" -o "$kx_file"; then
	echo "Downloaded kx.sh to $kx_file"
else
	echo "Failed to download kx.sh from $kx_url"
	exit 1
fi

# Detect the current shell
current_shell=$(basename "$SHELL")

case "$current_shell" in
bash)
	append "$HOME/.bashrc"
	;;
zsh)
	append "$HOME/.zshrc"
	;;
fish)
	append "$HOME/.config/fish/config.fish"
	;;
ksh)
	append "$HOME/.kshrc"
	;;
*)
	echo "Unsupported shell: $current_shell"
	;;
esac
