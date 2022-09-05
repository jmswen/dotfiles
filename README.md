## Installing zshrc

Local ~/.zshrc should essentially look like
```
source "$HOME"/dotfiles/zshrc
export PATH="/usr/local/opt/openssl@1.1:$PATH"
```

## Installing vimrc (for NeoVim)
* Run `make`
* Ensure neovim is installed, e.g., by running `brew install neovim`.
* Ensure `fzf` is installed, e.g., by running `brew install fzf`.
* Ensure `vim-plug` is installed. See [the GitHub page](https://github.com/junegunn/vim-plug) for installation instructions.

## VS Code .json configuration files
The `keybindings.json` and `settings.json` files should be copied into the `~/Library/Application\ Support/Code/User/` directory, assuming vanilla VS Code is installed on macOS.
