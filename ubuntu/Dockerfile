FROM ubuntu:xenial
MAINTAINER dev@parafuzo.com

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -yq \
  && apt-get -yq install locales tzdata build-essential python ca-certificates curl wget bindfs vim git-core zlib1g-dev \
    autoconf imagemagick libbz2-dev libevent-dev libglib2.0-dev libjpeg-dev libmagickcore-dev gcc \
    libmagickwand-dev libncurses-dev libcurl4-openssl-dev libffi-dev libgdbm-dev libpq-dev libc6-dev \
    libreadline-dev libreadline6-dev libssl-dev libtool libxml2-dev libxslt-dev libyaml-dev \
    software-properties-common zlib1g-dev mongodb mysql-client libmysqlclient-dev sqlite3 libsqlite3-dev \
  && apt-get clean -qq \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# ==============================================================================
# Node 8.1.0
# ==============================================================================

RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.1.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# ==============================================================================
# Yarn 0.24.6
# ==============================================================================

ENV YARN_VERSION 0.24.6

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

# ==============================================================================
# PhantomJS 2.1.1
# ==============================================================================

ENV PHANTOMJS_VERSION 2.1.1

RUN cd /usr/local/share \
  && curl -SLO https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs \
  && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

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

ENV RUBYGEMS_MAJOR 2.6
ENV RUBYGEMS_VERSION 2.6.8

# Install rubygems and bundler
ADD http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz /tmp/
RUN cd /tmp \
  && tar -zxf /tmp/rubygems-$RUBYGEMS_VERSION.tgz \
  && cd /tmp/rubygems-$RUBYGEMS_VERSION \
  && ruby setup.rb \
  && /bin/bash -l -c 'gem install bundler --no-rdoc --no-ri' \
  && echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
  && rm -rf /tmp/* /var/tmp/*

WORKDIR /app

CMD ["bash"]
