FROM centos:latest

LABEL maintainer="Chen Augus <tianhao.chen@gmail.com>"

RUN yum install -y epel-release && \
    yum install -y git nginx python2-pip gcc python-devel ImageMagick && \
    mkdir -p /opt/calibre /opt/calibre-library && cd /opt/calibre && \
    git clone -b master https://github.com/janeczku/calibre-web.git && \
    cd /opt/calibre/calibre-web && pip install --upgrade pip && \
    pip install --target vendor -r requirements.txt && \
    pip install --target vendor -r optional-requirements.txt

COPY calibre-library /opt/calibre-library
COPY scripts/entrypoint.sh /opt/calibre/calibre-web/entrypoint.sh
COPY scripts/nginxreverse.conf /etc/nginx/conf.d/default.conf

VOLUME ["/etc/nginx", "/opt/calibre-library"]

EXPOSE 80 443 8083

WORKDIR /opt/calibre/calibre-web

ENTRYPOINT [ "sh", "/opt/calibre/calibre-web/entrypoint.sh" ]