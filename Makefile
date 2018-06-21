DOTFILES_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

nvim:
	test -f ~/.config/nvim/init.vim || \
	  ln -s ~/.config/nvim/init.vim $(DOTFILES_DIR)/vimrc
	test -f ~/.config/nvim/autoload/mycstyle.vim || ( \
	  mkdir -p ~/.config/nvim/autoload/ && \
	  ln -s ~/.config/nvim/autoload/mycstyle.vim $(DOTFILES_DIR)/mycstyle.vim \
	)

tmux:
	test -f ~/.tmux.conf || \
	  ln -s $(DOTFILES_DIR)/tmux.conf ~/.tmux.conf

zsh:
	test -f ~/.zshrc || \
	  ln -s $(DOTFILES_DIR)/zshrc ~/.zshrc

all:	nvim tmux zsh
