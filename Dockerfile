FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /watchdocs-backend
WORKDIR /watchdocs-backend
ADD Gemfile /watchdocs-backend/Gemfile
ADD Gemfile.lock /watchdocs-backend/Gemfile.lock
RUN bundle install
ADD . /watchdocs-backend
