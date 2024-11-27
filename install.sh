#!/usr/bin/env bash

### NOTES ###
# Run from within the dotfiles folder for relative filepaths to work

DOTFILES_ROOT=$PWD
DOTFILES_INSTALLATION_DIR=$HOME/.dotfiles-installation
rm -r $DOTFILES_INSTALLATION_DIR
mkdir $DOTFILES_INSTALLATION_DIR

# If linux, install linux stuff
if [[ "$OSTYPE" == "linux-gnu"* ]]; then


  # neovim:latest via appimage
  mkdir $DOTFILES_INSTALLATION_DIR/nvim
  cd $DOTFILES_INSTALLATION_DIR/nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  rm /usr/local/bin/nvim
  ln -s $DOTFILES_INSTALLATION_DIR/nvim/squashfs-root/AppRun /usr/local/bin/nvim
  nvim --version

  # Install lua itself
  mkdir $DOTFILES_INSTALLATION_DIR/lua
  cd $DOTFILES_INSTALLATION_DIR/lua
  curl -R -O https://www.lua.org/ftp/lua-5.3.5.tar.gz
  tar -zxf lua-5.3.5.tar.gz
  cd lua-5.3.5 && make linux test && make install
  
  # Install luarocks pkg manager for neovim
  mkdir $DOTFILES_INSTALLATION_DIR/luarocks
  cd $DOTFILES_INSTALLATION_DIR/luarocks
  curl -R -O http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
  tar -zxf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1 && ./configure --with-lua-include=/usr/local/include && make && make install
  
  # Install pandoc 2.19.2 -- this is the specific version I prefer, due to compatibility with the pandoc python package
  mkdir $DOTFILES_INSTALLATION_DIR/pandoc && cd $DOTFILES_INSTALLATION_DIR/pandoc
  curl -LO https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-1-amd64.deb
  dpkg -i pandoc*.deb && rm *.deb
fi

# link dotfiles to the .dotfiles for easy access
if [[ $DOTFILES_ROOT != $HOME/.dotfiles ]]; then
  ln -sfn $DOTFILES_ROOT $HOME/.dotfiles
fi

# link all dotfiles to appropriate config folders
# create main .config folder
mkdir -p $HOME/.config
# install neovim configs
rm $HOME/.config/nvim
ln -sfn $DOTFILES_ROOT/nvim $HOME/.config/nvim
nvim --headless "+Lazy! sync" +qa
# install code-server configs
ln -sfn $DOTFILES_ROOT/code-server/keybindings.json $HOME/.local/share/code-server/User/keybindings.json

# bashrc & zshrc
ln -sfn $DOTFILES_ROOT/dot.bashrc $HOME/.bashrc
ln -sfn $DOTFILES_ROOT/dot.zshrc $HOME/.zshrc