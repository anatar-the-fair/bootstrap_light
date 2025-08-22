# --- Source custom shortcut/alias configs if they exist ---
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
for rcfile in shortcutrc shortcutenvrc aliasrc zshnameddirrc; do
  [ -f "$CONFIG_DIR/$rcfile" ] && source "$CONFIG_DIR/$rcfile"
done

source "$HOME/.config/shell/profile"

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# --- Basic shell options ---
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines

# fzf setup
source <(fzf --zsh) # allow for fzf history widget

eval "$(zoxide init --cmd cd zsh)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# binds
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^j" backward-word
bindkey "^k" forward-word
bindkey "^H" backward-kill-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
bindkey '^R' fzf-history-widget

NEWLINE=$'\n'
PROMPT="%F{blue}%~%f${NEWLINE}❯ "

for plugin in zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting zsh-you-should-use; do
  PLUGIN_PATH="$HOME/.local/share/zsh/plugins/$plugin/$plugin.plugin.zsh"
  if [[ -f "$PLUGIN_PATH" ]]; then
    source "$PLUGIN_PATH"
  else
    echo "Warning: $plugin not found at $PLUGIN_PATH"
  fi
done

# Ensure zsh-history-substring-search bindings for arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
