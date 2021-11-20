#!/bin/bash

mkdir -p ~/.config/mopidy
mkdir -p ~/.local
gsutil rsync gs://$GCS_BUC/config/mopidy ~/.config/mopidy
gsutil rsync -r gs://$GCS_BUC/.local ~/.local

mopidy &
pid=$!

syncLocalFiles() {
gsutil rsync -r  ~/.local gs://$GCS_BUC/.local 
exit
}
trap 'syncLocalFiles' SIGTERM 
trap 'syncLocalFiles' SIGINT
trap 'syncLocalFiles' SIGTSTP

wait $pid

