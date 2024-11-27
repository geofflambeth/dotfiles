#!/usr/bin/env bash

### NOTES ###
# Keep dotfiles repo at $HOME/.dotfiles or use $DEPLOY_HOME env variable 

if [[ -z "${DEPLOY_HOME}" ]]; then
  INSTALL_DIR="${HOME}/dotfiles" # get install dir from $HOME because $DEPLOY_HOME is not set
else
  INSTALL_DIR="${DEPLOY_HOME}"
fi

# If linux, install linux stuff
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version
  ln -s /squashfs-root/AppRun /usr/bin/nvim

  # Install lua itself
  curl -R -O https://www.lua.org/ftp/lua-5.3.5.tar.gz
  tar -zxf lua-5.3.5.tar.gz
  cd lua-5.3.5 && make linux test && make install
  
  # Install luarocks pkg manager for neovim
  curl -R -O http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
  tar -zxf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1 && ./configure --with-lua-include=/usr/local/include && make && make install
  
  # Install pandoc 2.19.2
  curl -LO https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-1-amd64.deb
  dpkg -i pandoc*.deb && rm *.deb
fi

# link all dotfiles to config folder
# create main .config folder
mkdir -p $HOME/.config
# install neovim configs
ln -sfn $INSTALL_DIR/nvim $HOME/.config/nvim
nvim --headless "+Lazy! sync" +qa
