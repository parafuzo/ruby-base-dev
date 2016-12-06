FROM ubuntu:trusty
MAINTAINER dev@parafuzo.com

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update \
  && apt-get upgrade -yq \
  && apt-get -yq install build-essential python ca-certificates curl wget bindfs vim git-core zlib1g-dev \
    autoconf imagemagick libbz2-dev libevent-dev libglib2.0-dev libjpeg-dev libmagickcore-dev \
    libmagickwand-dev libncurses-dev libcurl4-openssl-dev libffi-dev libgdbm-dev libpq-dev \
    libreadline-dev libreadline6-dev libssl-dev libtool libxml2-dev libxslt-dev libyaml-dev \
    software-properties-common zlib1g-dev mongodb mysql-client libmysqlclient-dev sqlite3 libsqlite3-dev \
  && apt-get clean -qq \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ==============================================================================
# Node 7.2.0
# ==============================================================================

RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 7.2.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

# ==============================================================================
# PhantomJS 2.1.1
# ==============================================================================

ENV PHANTOMJS_VERSION 2.1.1

RUN \
  cd /usr/local/share && \
  curl -L -O "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" && \
  tar xjf "phantomjs-$PHANTOMJS_VERSION-linux-x86_64-linux-x86_64.tar.bz2" && \
  ln -s "/usr/local/share/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs" /usr/local/share/phantomjs && \
  ln -s "/usr/local/share/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs" /usr/local/bin/phantomjs && \
  ln -s "/usr/local/share/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs" /usr/bin/phantomjs

# Global install yarn package manager
RUN npm set progress=false \
  && npm install -g --progress=false yarn

# ==============================================================================
# Ruby 2.2.6
# ==============================================================================

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.6

# Set $PATH so that non-login shells will see the Ruby binaries
ENV PATH $PATH:/opt/rubies/ruby-$RUBY_VERSION/bin

# Install MRI Ruby $RUBY_VERSION
RUN curl -O http://ftp.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz \
  && tar -zxvf ruby-$RUBY_VERSION.tar.gz \
  && cd ruby-$RUBY_VERSION \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && cd .. \
  && rm -r ruby-$RUBY_VERSION ruby-$RUBY_VERSION.tar.gz \
  && echo 'gem: --no-document' > /usr/local/etc/gemrc

# ==============================================================================
# Rubygems and Bundler
# ==============================================================================

ENV RUBYGEMS_MAJOR 2.3
ENV RUBYGEMS_VERSION 2.3.0

# Install rubygems and bundler
ADD http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz /tmp/
RUN cd /tmp \
  && tar -zxf /tmp/rubygems-$RUBYGEMS_VERSION.tgz \
  && cd /tmp/rubygems-$RUBYGEMS_VERSION \
  && ruby setup.rb \
  && /bin/bash -l -c 'gem install bundler --no-rdoc --no-ri' \
  && echo "gem: --no-ri --no-rdoc" > ~/.gemrc
  && rm -rf /tmp/* /var/tmp/*

WORKDIR /app

CMD ["bash"]
