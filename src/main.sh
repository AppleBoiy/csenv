#!/usr/bin/env bash


# get all input including flags
INPUTS=("$@")

# get all flags
FLAGS=()

# get all arguments
ARGS=()

for i in "${INPUTS[@]}"; do
  if [[ $i == -* ]]; then
    FLAGS+=("$i")
  else
    ARGS+=("$i")
  fi
done

brew_version() {
  brew --version
}

ARGS_LENGTH=${#ARGS[@]}

if [[ $ARGS_LENGTH -eq 0 ]]; then
  echo "No arguments provided"
  exit 1
fi

case ${ARGS[0]} in
  brew_version)
    brew_version
    ;;
  install)
    case ${ARGS[1]} in
      # need python3.10
      cs111)
        # check if python3.10 is installed
        if ! command -v python3.10 &> /dev/null; then
          echo "Python3.10 is not installed. Install python3.10"
          brew install python@3.10 || exit 1
        fi
        
        # check if python3.10 is linked
        if ! brew list python@3.10 &> /dev/null; then
          echo "Python3.10 is not linked. Link python3.10"
          brew link python@3.10 || exit 1
        fi
      *)
        echo "Command not found"
        ;;
    esac
  *)
    echo "Command not found"
    ;;
esac
