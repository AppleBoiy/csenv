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
  *)
    echo "Command not found"
    ;;
esac
