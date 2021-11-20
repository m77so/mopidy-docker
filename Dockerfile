FROM gcr.io/google.com/cloudsdktool/cloud-sdk:365.0.0-slim

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1
RUN apt-get install wget
RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
RUN apt-get update && apt-get -y install mopidy mopidy-spotify nginx
RUN pip3 install Mopidy-Iris

COPY entrypoint.sh /root/

ENTRYPOINT ["/bin/bash", "/root/entrypoint.sh"]

