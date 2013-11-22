#! /bin/sh

REDMINE_VERSION="2.4.0"

# deploy redmine
wget http://rubyforge.org/frs/download.php/77242/redmine-${REDMINE_VERSION}.tar.gz
tar zxf redmine-${REDMINE_VERSION}.tar.gz

ls -al

# copy plugin files
mkdir plugins/redmine_bx
cp -r app     plugins/redmine_bx/app
cp -r assets  plugins/redmine_bx/assets
cp -r config  plugins/redmine_bx/config
cp -r db      plugins/redmine_bx/db
cp -r lib     plugins/redmine_bx/lib
cp -r spec    plugins/redmine_bx/spec
cp -r test    plugins/redmine_bx/test
cp Gemfile    plugins/redmine_bx/Gemfile
cp init.rb    plugins/redmine_bx/init.rb

# create files
cd redmine-${REDMINE_VERSION}
cat > config/database.yml <<_EOS_
test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_
cp plugins/redmine_bx/test/fixtures/* test/fixtures/

