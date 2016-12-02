FROM parafuzo/ruby-base
MAINTAINER dev@parafuzo.com

RUN npm install --global yarn

CMD ["/bin/sh"]
