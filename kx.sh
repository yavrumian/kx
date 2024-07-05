#!/bin/bash
kx() {
	# set -x
	# Initialize namespace variable only if it's not already set
	local pod=$1
	local cmd=$2
	if [[ $# -eq 1 || $# -eq 3 ]]; then
		local cmd=$1
	fi
	local namespace OPTIND n opt args
	namespace=""
	OPTIND=1
	args=$#
	echo "number of args: $args"
	# Parse arguments for namespace
	if [[ $args -gt 2 ]]; then
		OPTIND=$(($args - 1))
		echo "in here"
	fi
	echo "opt $OPTIND"
	while getopts "n:" opt; do
		case $opt in
		n)
			namespace="-n $OPTARG"
			args=$(($args - 2))
			echo "# $args"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			return 1
			;;
		esac
	done
	shift $((OPTIND - 1))
	echo $namespace
	# Check the number of parameters passed to the function
	if [[ $args -eq 1 ]]; then
		# Get the list of pods and use fzf to select one
		local pod=$(kubectl get pods $namespace --no-headers -o custom-columns=":metadata.name" | fzf --height 90% --reverse --prompt="Select a pod: ")
		# Check if a pod was selected
		if [[ -n "$pod" ]]; then
			# Run the kx command with the chosen pod and input command
			kx "$pod" "$cmd" $namespace
		else
			echo "No pod selected."
		fi
	elif [[ $args -eq 2 ]]; then
		# local pod="$1"
		# local cmd="$2"
		echo "======= $# ======"
		# Run the kx command with the provided pod and input command
		kubectl exec $namespace $pod -it -- $cmd
	else
		# Get the list of pods and use fzf to select one
		local pod=$(kubectl get pods $namespace --no-headers -o custom-columns=":metadata.name" | fzf --height 90% --reverse --prompt="Select a pod: ")
		# Check if a pod was selected
		if [[ -n "$pod" ]]; then
			# Prompt for additional input
			read -p "Enter the command: " cmd
			# Run the kx command with the chosen pod and input
			kx "$pod" "$cmd" $namespace
		else
			echo "No pod selected."
		fi
	fi
}
