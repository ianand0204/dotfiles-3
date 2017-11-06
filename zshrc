source <(antibody init)
export PATH=/usr/local/bin:$PATH
export DOTFILES="$HOME/dotfiles"

# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/*/*.zsh)

for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

source ~/.zsh_plugins.sh
# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
autoload -Uz promptinit
promptinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files updated_at

# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
# shellcheck disable=SC1090
[ -f ~/.localrc ] && . ~/.localrc
