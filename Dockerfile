FROM reiz/ruby:2.2.3
MAINTAINER  Robert Reiz <reiz@versioneye.com>

ENV RAILS_ENV test
ENV BUNDLE_GEMFILE /rails/Gemfile

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /rails

RUN apt-get install -y libfontconfig1 # mandatory for PDFKit

RUN gem install rubygems-update
RUN update_rubygems
RUN gem update --system

RUN gem install bundler --version 1.10.6

RUN wget -O /usr/local/lib/ruby/site_ruby/2.2.0/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem

RUN rm -Rf /rails; mkdir -p /rails; mkdir -p /rails/log; mkdir -p /rails/pids

COPY Gemfile Gemfile.lock /rails/

RUN bundle install

COPY . /rails