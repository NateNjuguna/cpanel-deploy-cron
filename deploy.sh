#!/bin/bash

export TMPDIR="$HOME/tmp"

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

if hash node 2>/dev/null; then
    echo "NodeJS found. Using `which node`"
else
    echo "NodeJS not found Installing NodeJS..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install --lts
fi

_UAPI_BIN=`which uapi`
cd `dirname $0`

for _LOCK_FILE in *.lock; do
    if [ -f $_LOCK_FILE ]; then
        _PROJECT=${_LOCK_FILE%.lock}
        _REPOSITORY_BRANCH=`node -e "process.stdout.write((require('./config.json')['$_PROJECT'] || {}).branch)"`
        _REPOSITORY_ROOT=`node -e "process.stdout.write((require('./config.json')['$_PROJECT'] || {}).repository)"`
        $_UAPI_BIN VersionControl update branch=$_REPOSITORY_BRANCH repository_root=$_REPOSITORY_ROOT
        $_UAPI_BIN VersionControlDeployment create repository_root=$_REPOSITORY_ROOT
        rm $_LOCK_FILE
    fi
done
