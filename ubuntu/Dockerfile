FROM azukiapp/node
MAINTAINER dev@parafuzo.com

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.6

# Set $PATH so that non-login shells will see the Ruby binaries
ENV PATH $PATH:/opt/rubies/ruby-$RUBY_VERSION/bin

# Install MRI Ruby $RUBY_VERSION
RUN curl -O http://ftp.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz && \
    tar -zxvf ruby-$RUBY_VERSION.tar.gz && \
    cd ruby-$RUBY_VERSION && \
    ./configure --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-$RUBY_VERSION ruby-$RUBY_VERSION.tar.gz && \
    echo 'gem: --no-document' > /usr/local/etc/gemrc

# ==============================================================================
# Rubygems and Bundler
# ==============================================================================

ENV RUBYGEMS_MAJOR 2.3
ENV RUBYGEMS_VERSION 2.3.0

# Install rubygems and bundler
ADD http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz /tmp/
RUN cd /tmp && \
    tar -zxf /tmp/rubygems-$RUBYGEMS_VERSION.tgz && \
    cd /tmp/rubygems-$RUBYGEMS_VERSION && \
    ruby setup.rb && \
    /bin/bash -l -c 'gem install bundler --no-rdoc --no-ri' && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN apt-get install nodejs curl python && \
    npm install -g yarn

# Phantomjs 1.9.7
RUN \
  cd /usr/local/share && \
  curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
  tar xjf phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
  ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs && \
  ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
  ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

WORKDIR /app

CMD ["bash"]
