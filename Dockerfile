FROM gcr.io/google.com/cloudsdktool/cloud-sdk:365.0.0-slim

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1
RUN apt-get install wget
RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
RUN wget -q -O ~/snapserver.deb https://github.com/badaix/snapcast/releases/download/v0.25.0/snapserver_0.25.0-1_amd64.deb

RUN apt-get update && apt-get -y install mopidy mopidy-spotify mopidy-local ~/snapserver.deb nginx gettext-base
RUN pip3 install Mopidy-Iris 

COPY snapserver.conf /etc/
COPY entrypoint.sh /root/
COPY nginx.conf.template /root/
COPY mopidy.conf.template /root/
COPY .htpasswd /etc/nginx/.htpasswd

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "/root/entrypoint.sh"]

