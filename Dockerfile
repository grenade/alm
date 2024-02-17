FROM alpine:latest
RUN apk add --update --no-cache \
  bash \
  ca-certificates \
  curl \
  doas \
  gcompat \
  git \
  libstdc++ \
  openssh \
  tar
RUN rm -rf /var/cache/apk/*
ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz /tmp
RUN tar zxf /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz --strip-components=1 -C /usr/local/bin
RUN rm /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN adduser -D -G wheel -h /home/grenade -s /bin/bash grenade
RUN echo 'permit grenade as root' > /etc/doas.d/doas.conf
RUN mkdir -p /home/grenade/.ssh
RUN chmod 700 /home/grenade/.ssh
ADD https://github.com/grenade.keys /tmp
COPY --chmod=0644 /tmp/grenade.keys /home/grenade/.ssh/authorized_keys
RUN rm /tmp/grenade.keys
EXPOSE 22

USER grenade

ENTRYPOINT /bin/bash
