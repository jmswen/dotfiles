DOTFILES_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# If any of these commands fails due to a pre-existing file, the user must
# manually "install" however they see fit. For example, a pre-existing .vimrc
# or init.vim file could `source` this repo's vimrc file.

all:	nvim tmux zsh

nvim:
	test -f ~/.config/nvim/init.vim || \
	  ln -s $(DOTFILES_DIR)/vimrc ~/.config/nvim/init.vim
	test -f ~/.config/nvim/autoload/mycstyle.vim || ( \
	  mkdir -p ~/.config/nvim/autoload/ && \
	  ln -s $(DOTFILES_DIR)/mycstyle.vim ~/.config/nvim/autoload/mycstyle.vim \
	)

tmux:
	test -f ~/.tmux.conf || \
	  ln -s $(DOTFILES_DIR)/tmux.conf ~/.tmux.conf

zsh:
	test -f ~/.zshrc || \
	  ln -s $(DOTFILES_DIR)/zshrc ~/.zshrc
