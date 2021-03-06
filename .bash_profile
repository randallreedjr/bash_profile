# Configuring Our Prompt
# ======================

  # if you install git via homebrew, or install the bash autocompletion via homebrew, you get __git_ps1 which you can use in the PS1
  # to display the git branch.  it's supposedly a bit faster and cleaner than manually parsing through sed. i dont' know if you care
  # enough to change it

  # This function is called in your prompt to output your active git branch.
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # This function builds your prompt. It is called below
  function prompt {
    # Define some local colors
    local         RED="\[\033[0;31m\]" # This syntax is some weird bash color thing I never
    local   LIGHT_RED="\[\033[1;31m\]" # really understood
    local      ORANGE="\[\033[1;91m\]"
    local      YELLOW="\[\033[1;33m\]"
    local        CHAR="☆"
    # ♥ ☆ - Keeping some cool ASCII Characters for reference

    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$ORANGE\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[1;33m\]$CHAR \[\e[0m\]"
      PS2='> '
      PS4='+ '
    }

  # Finally call the function and our prompt is all pretty
  prompt

  # For more prompt coolness, check out Halloween Bash:
  # http://xta.github.io/HalloweenBash/

  # If you break your prompt, just delete the last thing you did.
  # And that's why it's good to keep your dotfiles in git too.

# Environment Variables
# =====================
  # Library Paths
  # These variables tell your shell where they can find certain
  # required libraries so other programs can reliably call the variable name
  # instead of a hardcoded path.

    # NODE_PATH
    # Node Path from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    # Those NODE & Python Paths won't break anything even if you
    # don't have NODE or Python installed. Eventually you will and
    # then you don't have to update your bash_profile

  # Configurations

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

    # Editors
    # Tells your shell that when a program requires various editors, use Atom.
    # The -w flag tells your shell to wait until Atom exits
    export VISUAL="atom -w"
    export SVN_EDITOR="atom -w"
    export GIT_EDITOR="atom -w"
    export EDITOR="atom -w"

    # Paths
    if [ -d $(brew --prefix qt@5.5)/bin ]; then
      export QT_PATH="$(brew --prefix qt@5.5)/bin"
    else
      export QT_PATH=""
    fi

    export VS_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    # The USR_PATHS variable will just store all relevant /usr paths for easier usage
    # Each path is seperate via a : and we always use absolute paths.

    # A bit about the /usr directory
    # The /usr directory is a convention from linux that creates a common place to put
    # files and executables that the entire system needs access too. It tries to be user
    # independent, so whichever user is logged in should have permissions to the /usr directory.
    # We call that /usr/local. Within /usr/local, there is a bin directory for actually
    # storing the binaries (programs) that our system would want.
    # Also, Homebrew adopts this convetion so things installed via Homebrew
    # get symlinked into /usr/local
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"
    # Hint: You can interpolate a variable into a string by using the $VARIABLE notation as below.

    # We build our final PATH by combining the variables defined above
    # along with any previous values in the PATH variable.

    # Our PATH variable is special and very important. Whenever we type a command into our shell,
    # it will try to find that command within a directory that is defined in our PATH.
    # Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
    export PATH="$USR_PATHS:$PATH:$VS_PATH:$QT_PATH"

    # If you go into your shell and type: $PATH you will see the output of your current path.
    # For example, mine is:
    # /Users/avi/.rvm/gems/ruby-1.9.3-p392/bin:/Users/avi/.rvm/gems/ruby-1.9.3-p392@global/bin:/Users/avi/.rvm/rubies/ruby-1.9.3-p392/bin:/Users/avi/.rvm/bin:/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/local/mysql/bin:/usr/local/share/python:/bin:/usr/sbin:/sbin:

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desktop.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Aliases
# =====================

  # Load aliases from .bashrc
  # eval "$(cat ~/.bashrc | grep alias)"
  source ~/.bashrc

  # Bash
  alias l='ls -lah'
  alias refresh='rm ~/.bash_profile && ln -s ~/Code/bash_profile/.bash_profile ~/.bash_profile && source ~/.bash_profile && cd .'

  # git
  alias prune='git fetch --prune --all'
  alias gap='git add -p'

  # Rails
  alias be="bundle exec"
  alias bi="bundle install"
  alias migrate="bundle exec rake db:migrate"
  alias rollback="bundle exec rake db:rollback"
  alias rc="bundle exec rails console"
  alias rs="bundle exec rails server"

  # Heroku
  alias hpmigrate="heroku run bundle exec rake db:migrate -r heroku"
  alias hpconsole="heroku run bundle exec rails console -r heroku"
  alias hsmigrate="heroku run bundle exec rake db:migrate -r staging"
  alias hsconsole="heroku run bundle exec rails console -r staging"

  # Rspec
  alias rspec="bundle exec rspec"
  alias rff="bundle exec rspec --fail-fast"
  alias s="SILENCE_SPECS=true ./scripts/build.sh -q"

  # Home
  alias co="cd ~/Code"
  alias bp="cd ~/Code/bash_profile"
  alias rr="cd ~/Code/Personal/randallreedjr.com"
  alias dm="cd ~/Code/DefMethod"
  alias ss="cd ~/Code/Freelance/screen-slate-cms"
  alias uis="cd ~/Code/Codecademy/Build\ Website\ UIs"

  # Wellinks
  alias hcb="ssh rreed@44c7a70f0551c3d6d5ed.healthcareblocks.com"
  alias cinch="cd ~/Code/DefMethod/Wellinks/cinch-web"

  # XO
  alias mkt="cd ~/Code/Marketplace"
  alias lint="sh script/git_hooks/pronto.sh"

  # Profiles
  alias git-randy="git config user.email \"randy@defmethod.io\"; git config user.username \"dm-randy\"; git config user.email"
  alias git-randallreedjr="git config --global user.email \"randallreedjr@gmail.com\"; git config --global user.username \"randallreedjr\"; git config --unset user.email; git config --unset user.username; git config user.email"
  alias git-xo="git config user.email \"rareed@xogrp.com\"; git config user.username \"rareed\"; git config user.email"
  alias me="echo local; whoami; echo github; git config user.email; echo heroku; heroku auth:whoami"

# Final Configurations and Plugins
# =====================
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # RVM
  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always

  # Make autocompletion case insensitive
  bind "set completion-ignore-case on"

# Allow git autocompletion
  if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
  fi

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# nvm
if [ -d $(brew --prefix nvm) ]; then
  # installed via homebrew
  export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"
else
  # installed via github
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


# Git Undo
export GIT_UNDO_HISTFILE=$HISTFILE
alias git-undo="HISTFILE=$HISTFILE git-undo"

# Flush history immediately
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
