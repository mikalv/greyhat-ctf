#!/bin/bash

export ROOT_DIR=${GREYHAT_CTF_ROOT_DIR:-`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`}
export VENV_DIR="$ROOT_DIR/_venv"
export GREYHAT_CTF_BINDIR="$ROOT_DIR/bin"
export ENV_SOURCE_FILE="$ROOT_DIR/environment.source"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "[-] Missing virtual environment for python, setting up..."
  command -v virtualenv >/dev/null 2>&1 || { echo >&2 "I require virtualenv (python pip package) but it's not installed.  Aborting."; exit 1; }
  virtualenv "$VENV_DIR"
fi

source $VENV_DIR/bin/activate
echo "[+] Enabled the virtual environment"

# Check for ansible
command -v ansible >/dev/null 2>&1 || { pip install ansible || echo "Failed to install ansible, exiting!";exit 1; }
echo "[+] Found ansible"

if [[ ! -f "$ENV_SOURCE_FILE" ]]; then
  echo "# Environment file for shell scripts" > $ENV_SOURCE_FILE
  echo "source $VENV_DIR/bin/activate" >> $ENV_SOURCE_FILE
  echo "export GREYHAT_CTF_ROOT_DIR=$ROOT_DIR" >> $ENV_SOURCE_FILE
  echo "export PATH=$PATH:$ROOT_DIR/bin" >> $ENV_SOURCE_FILE
  echo "" >> $ENV_SOURCE_FILE
  echo "" >> $ENV_SOURCE_FILE
fi

echo "[+] Workspace install is done!"
echo "[+] Remember to source the environment file :)"
echo "[+] In terminal: source $ENV_SOURCE_FILE"
if [[ "`uname -s`" == "Darwin" ]]; then
  echo -e "source $ENV_SOURCE_FILE\n" | pbcopy
  echo "[+] Btw, noticed you using Mac OS X, so I already put it in your clipboard. Hit Cmd+v"
fi
