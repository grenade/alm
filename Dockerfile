FROM public.ecr.aws/docker/library/alpine:latest
RUN apk add --update --no-cache \
  bash \
  ca-certificates \
  curl \
  doas \
  gcompat \
  git \
  libstdc++ \
  openrc \
  openssh \
  tar
ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz /tmp
RUN tar zxf /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz --strip-components=1 -C /usr/local/bin
RUN rm /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN addgroup grenade
RUN adduser \
  -h /home/grenade \
  -s /bin/bash \
  -D \
  -G grenade \
  grenade
RUN echo 'permit grenade as root' > /etc/doas.d/doas.conf
RUN mkdir -p /home/grenade/.ssh
RUN chmod 700 /home/grenade/.ssh
ADD https://github.com/grenade.keys /home/grenade/.ssh/authorized_keys
RUN chmod 644 /home/grenade/.ssh/authorized_keys
RUN chown -R grenade:grenade /home/grenade/.ssh

RUN sed -i 's/Port 22/Port 8080/g' /etc/ssh/sshd_config
rc-update add sshd

EXPOSE 8080

USER grenade

CMD /sbin/init
