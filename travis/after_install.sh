#! /bin/sh

REDMINE_LANG=en
RAILS_ENV=test

bundle exec rake generate_secret_token
bundle exec rake db:migrate
bundle exec rake redmine:load_default_data
bundle exec rake redmine:plugins NAME=redmine_bx

