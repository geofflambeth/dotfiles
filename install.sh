#!/usr/bin/env bash

### NOTES ###
# Keep .dotfiles repo at $HOME/.dotfiles or use $DEPLOY_HOME env variable 
if [[ -z "${DEPLOY_HOME}" ]]; then
  INSTALL_DIR="${HOME}/.dotfiles" # get install dir from $HOME because $DEPLOY_HOME is not set
else
  INSTALL_DIR="${DEPLOY_HOME}"
fi


# link all dotfiles to config folder
# create main .config folder
mkdir -p $HOME/.config
# install neovim configs
ln -sfn $INSTALL_DIR/nvim $HOME/.config/nvim
nvim --headless "+Lazy! sync" +qa
