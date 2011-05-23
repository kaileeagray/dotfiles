function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function superprompt {
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"

export PS1="\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\] \$ "
PS2='> '
PS4='+ '
}

superprompt
export JAVA_HOME="/usr"
export EVENT_NOKQUEUE=1

export VISUAL="mate -w"
export SVN_EDITOR="mate -w"
export GIT_EDITOR="mate -w"
export EDITOR="mate -w"

export EC2_HOME="/Users/avi/.ec2"
export EC2_PRIVATE_KEY="/Users/avi/.ec2/pk-UGSXAMQ752UUNWCAYLARZS6AL2GBVGL3.pem"
export EC2_CERT="/Users/avi/.ec2/cert-UGSXAMQ752UUNWCAYLARZS6AL2GBVGL3.pem"

export PATH="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/local/mysql/bin:$PATH"

# Aliases

# Folder Shortcuts
alias code="cd /Users/avi/Development/projects/Designerpages/code"
alias dp='cd /Users/avi/Development/projects/Designerpages/code/designerpages'
alias proj='cd /Users/avi/Development/projects/'

# Iterm Rails Project
alias s="iterm_rails_project.sh $1"

# Subversion
alias sup="svn update"
alias sst="svn status"
alias scom="svn commit"
alias sd="svn diff | mate"
alias slog="svn log | mate"
alias sex="svn export"
alias sad="svn add "
alias srm="svn remove "
alias sad="svn add "
alias sadd='svn status | grep "^\?" | awk "{print $2}" | xargs svn add' #adds all new files to svn
alias srmm='svn status | grep "\!"  | awk "{print $2;}" | xargs svn rm' #removes all missing files from svn

# Git
alias gst="git status"
alias gl="git pull"
alias gp="git push"
alias gd="git diff | mate"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"

# TextMate
alias et="mate . &"
alias ett="mate app config lib db public test spec vendor/plugins data features uploaders BRANCH Gemfile Rakefile &"

# Rails
alias kl_ruby="killall -9 ruby"

# Cucumber
alias buc='bundle exec cucumber -r features features'
alias bic='bundle exec cucumber -p wip'

# Bundler
alias bi='bundle install'

function ss {
  if [ -e script/rails ]; then
    script/rails server $@
  else
    script/server $@
  fi
}
function sc {
  if [ -e script/rails ]; then
    script/rails console $@
  else
    script/console $@
  fi
}
function sg {
  if [ -e script/rails ]; then
    script/rails generate $@
  else
    script/generate $@
  fi
}

# Ruby
alias sgi="sudo gem install "

# Memcached
alias kl_memcached="killall -9 memcached"

# MongoDB
alias s_mongo="mongod run --config /usr/local/Cellar/mongodb/1.6.0-x86_64/mongod.conf --logappend --fork"
alias kl_mongo="killall -9 mongod"

# A Better Rsynched Based SCP
alias scrp="rsync --partial --progress --rsh=ssh"

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# disk usage human readable AND sorted by size
# usage:
# duf /*
function duf {
	du -sk "$@" | sort -nr | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

# extract anything
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

# teach shell to treat aliases like symbolic links rather than files
function cd {
       if [ ${#1} == 0 ]; then
               builtin cd
       elif [[ -d "${1}" || -L "${1}" ]]; then # regular link or directory
               builtin cd "${1}"
       elif [ -f "${1}" ]; then        # file: is it an alias?
               # Redirect stderr to dev null to suppress OSA environment errors
               exec 6>&2 # Link file descriptor 6 with stderr so we can restore stderr later
               exec 2>/dev/null # stderr replaced by /dev/null
               path=$(osascript << EOF
tell application "Finder"
set theItem to (POSIX file "${1}") as alias
if the kind of theItem is "alias" then
get the posix path of ((original item of theItem) as text)
end if
end tell
EOF
)
               exec 2>&6 6>&-      # Restore stderr and close file descriptor #6.

               if [ "$path" == '' ];then # probably not an alias, but regular file
                       builtin cd "${1}"       # will trigger regular shell error about cd to regular file
               else    # is alias, so use the returned path of the alias
                       builtin cd "$path"
               fi
       else    # should never get here, but just in case.
               builtin cd "${1}"
       fi

}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.