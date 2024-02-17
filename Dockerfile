FROM public.ecr.aws/docker/library/node:20

RUN apt-get update

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
RUN git clone https://github.com/grenade/alm.git /home/alm/orchestrate
RUN chmod +x /home/alm/orchestrate/script/init.sh
WORKDIR /home/alm/orchestrate

CMD ["/home/alm/orchestrate/script/init.sh"]
