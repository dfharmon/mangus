#!/bin/bash
set -e

echo "Executing bundle exec 'rake db:migrate' ..."
RAILS_ENV=development bundle exec rake db:migrate
