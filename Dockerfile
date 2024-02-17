FROM public.ecr.aws/docker/library/node:20

RUN apt-get update
RUN apt-get install -y \
  openssh-server

RUN sed -i 's/Port 22/Port 8080/g' /etc/ssh/sshd_config
RUN systemctl enable ssh.service
EXPOSE 8080

ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz /tmp
RUN tar zxf /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz --strip-components=1 -C /usr/local/bin
RUN rm /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

RUN npm install -g npm
ENV TZ Asia/Muscat
ENV openshift_token ${openshift_token}

RUN useradd \
  --create-home \
  --home-dir /home/alm \
  --uid 1000770000 \
  --user-group \
  --group systemd-journal \
  alm

USER alm
RUN mkdir -p /home/alm/.ssh
RUN chmod 700 /home/alm/.ssh
ADD https://github.com/grenade.keys /home/alm/.ssh/authorized_keys

CMD ["journalctl", "-fu", "ssh.service"]
