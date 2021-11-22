#!/bin/bash

mkdir -p ~/.config/mopidy
mkdir -p ~/.local
gsutil rsync gs://$GCS_BUC/config/mopidy ~/.config/mopidy
sed -i -e "s/port_number/$PORT/" ~/.config/mopidy/mopidy.conf
gsutil rsync -r gs://$GCS_BUC/.local ~/.local

mopidy &
pid=$!

snapserver &
spid=$!

nginx -c ~/nginx.conf -g "daemon off;" &
npid=$!

syncLocalFiles() {
gsutil rsync -r  ~/.local gs://$GCS_BUC/.local 
exit
}
trap 'syncLocalFiles' SIGTERM 
trap 'syncLocalFiles' SIGINT
trap 'syncLocalFiles' SIGTSTP

wait $pid $spid  $npid

