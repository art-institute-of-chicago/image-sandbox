# To use Homebrew's directories rather than $HOME/.pyenv, use:
# export PYENV_ROOT="/usr/local/var/pyenv"

# Don't set PYENV_ROOT="~/.pyenv", macOS doesn't like the tilde

export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL="bash"

# To enable shims and autocompletion
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
