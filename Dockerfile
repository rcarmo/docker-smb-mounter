FROM ubuntu:16.04

RUN apt-get update && apt-get dist-upgrade -y && apt-get install \
    apt-transport-https \
    cifs.utils \
    -y --force-yes  \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose mounts
VOLUME /mnt
VOLUME /tmp

ADD start.sh /start.sh

CMD ["/start.sh"]

# Labels
ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.build-date=$BUILD_DATE
