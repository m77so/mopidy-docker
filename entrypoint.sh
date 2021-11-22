#!/bin/bash

mkdir -p ~/.config/mopidy
mkdir -p ~/.local
gsutil rsync -r gs://$GCS_BUC/.local ~/.local

envsubst '$$PORT $$HOSTNAME' < /root/nginx.conf.template > ~/nginx.conf
envsubst '$$PORT $$HOSTNAME' < /root/mopidy.conf.template > ~/.config/mopidy/mopidy.conf


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

wait $pid $spid $npid

