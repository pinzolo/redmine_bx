#! /bin/sh

REDMINE_VERSION="2.4.0"

# deploy redmine
wget http://rubyforge.org/frs/download.php/77242/redmine-${REDMINE_VERSION}.tar.gz
tar zxf redmine-${REDMINE_VERSION}.tar.gz

ls -al

# copy plugin files
mkdir redmine-${REDMINE_VERSION}/plugins/redmine_bx
mv -R app     plugins/redmine_bx/
mv -R assets  plugins/redmine_bx/
mv -R config  plugins/redmine_bx/
mv -R db      plugins/redmine_bx/
mv -R lib     plugins/redmine_bx/
mv -R spec    plugins/redmine_bx/
mv -R test    plugins/redmine_bx/
mv Gemfile    plugins/redmine_bx/
mv init.rb    plugins/redmine_bx/

# create files
cd redmine-${REDMINE_VERSION}
cat > config/database.yml <<_EOS_
test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_
cp plugins/redmine_bx/test/fixtures/* test/fixtures/

export BUNDLE_GEMFILE=./Gemfile

