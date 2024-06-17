#!/usr/bin/env bash

# Capture all input arguments and flags
INPUTS=("$@")

# Initialize arrays for flags and arguments
FLAGS=()
ARGS=()

# Separate flags and arguments
for i in "${INPUTS[@]}"; do
  if [[ $i == -* ]]; then
    FLAGS+=("$i")
  else
    ARGS+=("$i")
  fi
done

case ${FLAGS[0]} in
  -h|--help)
    echo "Usage: csenv [command] [package]"
    echo "Commands:"
    echo "  brew_version  Display brew version"
    echo "  install       Install a package"
    echo "Packages:"
    echo "  cs111         Install dependencies for CS111"
    ;;
esac

# Function to display brew version
brew_version() {
  brew --version
}

install_cs111() {
  # Check if python3.10 is installed
  if ! command -v python3.10 &> /dev/null; then
    echo "Python 3.10 is not installed. Installing python3.10..."
    brew install python@3.10 || { echo "Failed to install python3.10"; exit 1; }
  else
    echo "All Dependencies for CS111 are already installed"
    echo "[x] Python 3.10"          
    exit 0
  fi
  
  # Check if python3.10 is linked
  if ! brew list python@3.10 &> /dev/null; then
    echo "Python 3.10 is not linked. Linking python3.10..."
    brew link python@3.10 || { echo "Failed to link python3.10"; exit 1; }
  fi
}

# Check if there are any arguments
ARGS_LENGTH=${#ARGS[@]}
if [[ $ARGS_LENGTH -eq 0 ]]; then
  echo "No arguments provided"
  exit 1
fi

# Process the first argument
case ${ARGS[0]} in
  brew_version)
    brew_version
    ;;
  install)
    if [[ ${#ARGS[@]} -lt 2 ]]; then
      echo "No package specified for installation"
      exit 1
    fi
    case ${ARGS[1]} in
      cs111)
        install_cs111
        ;;
      *)
        echo "Unknown package: ${ARGS[1]}"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Unknown command: ${ARGS[0]}"
    exit 1
    ;;
esac
