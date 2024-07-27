#!/usr/bin/env bash

### NOTES ###
# Keep .dotfiles repo at $HOME/.dotfiles or use $DEPLOY_HOME env variable 
echo "this is a test"
if [[ -z "$(DEPLOY_HOME)" ]]; then
  INSTALL_DIR="$(HOME)/.dotfiles" # get install dir from $HOME because $DEPLOY_HOME is not set
else
  INSTALL_DIR="$(DEPLOY_HOME)"
fi


# link all dotfiles to config folder
mkdir -p $HOME/.config
ln -s $INSTALL_DIR/nvim $HOME/.config/nvim
