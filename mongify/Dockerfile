FROM ruby:alpine

RUN apk add --no-cache nano curl ruby-dev mysql-dev build-base perl

RUN gem install mongify activerecord-mysql2-adapter mysql2

RUN mkdir -p /mongify/config /mongify/data /mongify/bin

COPY database.config.template /mongify/config/database.config.template
COPY convert.sh /mongify/bin/convert.sh

WORKDIR /mongify/data

CMD ["/mongify/bin/convert.sh"]
