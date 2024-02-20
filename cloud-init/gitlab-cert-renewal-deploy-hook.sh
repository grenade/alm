#!/bin/sh

if [ ! -f /etc/gitlab/ssl/isrg-root-x1.pem ]; then
  curl \
    --silent \
    --location \
    --output /etc/gitlab/ssl/isrg-root-x1.pem \
    --url https://raw.githubusercontent.com/grenade/alm/main/cloud-init/subject-isrg-root-x1.pem
fi
if [ -f /etc/gitlab/ssl/gitlab.thgttg.com.crt ]; then
  rm /etc/gitlab/ssl/gitlab.thgttg.com.crt
fi
if [ -f /etc/gitlab/ssl/gitlab.thgttg.com.key ]; then
  rm /etc/gitlab/ssl/gitlab.thgttg.com.key
fi

cat \
  /etc/letsencrypt/live/gitlab.thgttg.com/fullchain.pem \
  /etc/gitlab/ssl/isrg-root-x1.pem \
  > /etc/gitlab/ssl/gitlab.thgttg.com.crt

ln -sf \
  /etc/letsencrypt/live/gitlab.thgttg.com/privkey.pem \
  /etc/gitlab/ssl/gitlab.thgttg.com.crt
