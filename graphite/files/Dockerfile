FROM debian:wheezy

MAINTAINER Christian Elberfeld <elberfeld@web.de>

COPY sources.list /etc/apt/sources.list 

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -y --force-yes build-essential locales git curl supervisor libreadline-dev zlib1g zlib1g-dev libbz2-dev libffi-dev libsqlite3-dev libssl-dev  && \
  locale-gen en_US.UTF-8 && \
  rm -fr /var/lib/apt/lists/*

ENV PATH /opt/python/bin:/usr/local/bin:$PATH

# install python
RUN \
  git clone git://github.com/yyuu/pyenv.git && \
  cd pyenv/plugins/python-build && \
  ./install.sh
RUN python-build 2.7.6 /opt/python
RUN locale-gen 

# install pip
RUN curl -s https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
RUN python /tmp/get-pip.py

ENV GRAPHITE_VERSION 0.9.15

# install graphite modules
RUN apt-get update && apt-get install -y libcairo2-dev --fix-missing && rm -fr /var/lib/apt/lists/*
RUN pip install http://cairographics.org/releases/py2cairo-1.8.10.tar.gz

RUN install -d -m 755 /var/lib/graphite
WORKDIR /var/lib/graphite
RUN pip install whisper==$GRAPHITE_VERSION --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib"
RUN curl -sL https://raw.githubusercontent.com/graphite-project/carbon/$GRAPHITE_VERSION/requirements.txt > /tmp/carbon-requirements.txt
RUN pip install -r /tmp/carbon-requirements.txt
RUN pip install carbon==$GRAPHITE_VERSION --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib"
RUN curl -sL https://raw.githubusercontent.com/graphite-project/graphite-web/$GRAPHITE_VERSION/requirements.txt > /tmp/graphite-requirements.txt
RUN pip install -r /tmp/graphite-requirements.txt
RUN pip install uwsgi==2.0.1
RUN pip install graphite-web==$GRAPHITE_VERSION --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib"

RUN install -d m 755 /var/log/graphite
COPY carbon.conf /var/lib/graphite/conf/carbon.conf
COPY storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
COPY local_settings.py /var/lib/graphite/lib/graphite/local_settings.py
COPY graphite.wsgi /var/lib/graphite/conf/graphite.wsgi
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN touch /var/log/graphite/info.log /var/log/graphite/exception.log /var/log/graphite/access.log /var/log/graphite/error.log

EXPOSE 8000 2003 2004 7002
VOLUME /var/lib/graphite/storage/whisper

CMD ["/entrypoint.sh"]
