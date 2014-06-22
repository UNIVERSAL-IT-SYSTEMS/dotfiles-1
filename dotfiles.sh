# PATH is defined in ~/.bashrc
# we must assume this has not happened yet
PATH=/bin:$PATH
sw=(
  "$HOMEDRIVE/Program Files"       "/Program Files"
  "$HOMEDRIVE/Program Files (x86)" "/Program Files (x86)"
  "$HOMEDRIVE/Repos"               "/Repos"
  "$HOMEDRIVE/Shell/bin"           "/Shell/bin"
  "$HOMEDRIVE/Shell/home"          "/home"
  "$HOMEDRIVE/Windows"             "/Windows"
  "$HOMEDRIVE/$USERNAME"           "/$USERNAME"
)
set "${sw[@]}"
while (( $# ))
do
  mount -f "$1" "$2"
  shift 2
done
mount -m >/etc/fstab

# PS1 must be exported before you can use ~
# we must assume this has not happened yet
mkdir -p   "$HOME"
echo cd >> "$HOME/.bash_history"
find -maxdepth 1 -type f -name '.*' -exec cp -t "$HOME" {} +
while [ -e $APPDATA/mozilla/firefox/default/places.sqlite-shm ]
do
  (( $# )) || printf 'Please close Firefox'
  set 0
  printf .
  sleep .5
done
find -maxdepth 1 -type d ! -name '.*' -exec cp -r -t "$APPDATA" {} +

# restart bash
pw=$(cygpath -m ~+)
cd "$pw"
cygstart bash
kill -7 $PPID $(ps | awk /daemon/,NF=1)