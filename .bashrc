# define variables and functions
EDITOR='cygstart -w'
HISTCONTROL=ignoredups
HISTIGNORE=c
HISTSIZE=10000
HOST=x86_64-w64-mingw32
LANG=C.utf8
PREFIX=/usr/x86_64-w64-mingw32/sys-root/mingw
PROMPT_COMMAND=pc
_PATH=(
  /home/bin                                # ffmpeg 1
  /programdata/chocolatey/bin              # ffmpeg 2
  /usr/local/bin                           # wish 1
  /usr/bin                                 # wish 2 sort 1
  /windows/system32                        #        sort 2
  /windows/system32/windowspowershell/v1.0 # wget
  /home/git/a
  /home/git/a/misc
  /home/git/apt-cyg
  /home/private/documents
)
IFS=: read PATH <<< "${_PATH[*]}"
unset _PATH

function c {
  printf '\ec'
}

function pc {
  history -a
  local hd
  if [ -d .git ]
  then
    read hd <.git/HEAD
    [[ $hd =~ / ]] && hd=${hd##*/} || hd=${hd::7}
    if [ ! -g .git/config ]
    then
      git config core.filemode 0
      chmod +s .git/config
    fi
  fi
  PS1="\e];\s\a\n\e[33m\w \e[36m$hd\n\[\e[m\]$ "
}

function wget {
  if command wget -h &>/dev/null
  then
    command wget "$@"
    return
  fi
  powershell '&{
  param([uri]$rc)
  if (!$rc.host) {$rc = "http://$rc"}
  $of = $rc.segments[-1]
  if (test-path $of) {"$of already there."} else {wget $rc -outf $of}
  }' ${*: -1} >&2
}

export EDITOR LANG
export -f wget
