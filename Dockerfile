FROM debian:jessie
MAINTAINER Nikita Tarasov <nikita@mygento.ru>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && apt-get upgrade -qqy

RUN apt-get install -qqy git apt-transport-https wget cron && apt-get clean

RUN apt-get install -qqy rubygems puppet && \
gem install --no-rdoc --no-ri activesupport -v 4.2.5 && \
gem install librarian-puppet --no-rdoc --no-ri && \
apt-get clean

# Run puppet
ONBUILD ADD Puppetfile /
ONBUILD RUN librarian-puppet install
ONBUILD ADD module.yaml /var/lib/hiera/common.yaml
ONBUILD RUN puppet apply --modulepath=/modules -e "hiera_include('classes')" --debug
