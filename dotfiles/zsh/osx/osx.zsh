# OS X specific settings

export PATH=~/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
export SVN_EDITOR='mate -w'
export GIT_EDITOR='mate -wl1'
export EDITOR='mate -w'
export GEM_OPEN_EDITOR='mate'
export LESSEDIT='mate -l %lm %f'

# Use OS X version of SSH with agent forwarding
alias ssh='/usr/bin/ssh -A'
alias scp='/usr/bin/scp'
alias sftp='/usr/bin/sftp'

alias ls='ls -ahGl'

fpath=(~/.dotfiles/zsh/osx/functions $fpath)
autoload -U ~/.dotfiles/zsh/osx/functions/*(:t)

localhost() {
  sudo dscl localhost -create /Local/Default/Hosts/$1 IPAddress 127.0.0.1
  echo "Added $1 at address 127.0.0.1"
}

ulimit -n 4096