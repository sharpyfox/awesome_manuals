#!/bin/sh

gem list --local

# Fix for "deprecated" warning on Ubuntu in travis
gem update --system 1.6.2

# Git repo of the Redmine

# Prepare Redmine
git clone --depth=100 --quiet $MAIN_REPO $TARGET_DIR
cd $TARGET_DIR
git checkout $REDMINE_GIT_TAG
git submodule update --init --recursive

# Copy over the already downloaded plugin 
cp -r ~/builds/*/$REPO_NAME vendor/plugins/$PLUGIN_DIR

#Fix for mocha "deprecated" warning
ruby -e "str = File.read('Gemfile');File.open('Gemfile', 'w+') { |file| file.write(str.gsub(/\"mocha\"$/, '\"mocha\", \"0.12.3\"')) }"

#export BUNDLE_GEMFILE=$TARGET_DIR/Gemfile
bundle install --without=rmagick:postgres:sqlite

echo "creating $DB database"
case $DB in
  "mysql" )
    mysql -e 'create database redmine_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql
  database: redmine_test
  username: root
EOF
    ;;
  "mysql2" )
    mysql -e 'create database redmine_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql2
  username: root
  encoding: utf8
  database: redmine_test
EOF
    ;;
  "postgres" )
    psql -c 'create database redmine_test;' -U postgres
    cat > config/database.yml << EOF
test:
  adapter: postgresql
  database: redmine_test
  username: postgres
EOF
    ;;
esac

bundle exec rake db:migrate
bundle exec rake db:migrate:plugins