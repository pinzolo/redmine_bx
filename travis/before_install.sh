#! /bin/sh

REDMINE_VERSION="2.4.1"

# Get & deploy Redmine
wget http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz
#wget http://rubyforge.org/frs/download.php/77242/redmine-${REDMINE_VERSION}.tar.gz
tar zxf redmine-${REDMINE_VERSION}.tar.gz

# Copy plugin files to plugin directory
mkdir redmine-${REDMINE_VERSION}/plugins/redmine_bx
mv app      redmine-${REDMINE_VERSION}/plugins/redmine_bx/app
mv assets   redmine-${REDMINE_VERSION}/plugins/redmine_bx/assets
mv config   redmine-${REDMINE_VERSION}/plugins/redmine_bx/config
mv db       redmine-${REDMINE_VERSION}/plugins/redmine_bx/db
mv lib      redmine-${REDMINE_VERSION}/plugins/redmine_bx/lib
mv spec     redmine-${REDMINE_VERSION}/plugins/redmine_bx/spec
mv test     redmine-${REDMINE_VERSION}/plugins/redmine_bx/test
mv Gemfile  redmine-${REDMINE_VERSION}/plugins/redmine_bx/Gemfile
mv init.rb  redmine-${REDMINE_VERSION}/plugins/redmine_bx/init.rb

# Create necessary files
cat > redmine-${REDMINE_VERSION}/config/database.yml <<_EOS_
test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_
cp redmine-${REDMINE_VERSION}/plugins/redmine_bx/test/fixtures/* redmine-${REDMINE_VERSION}/test/fixtures/

# All move to work directory
mv redmine-${REDMINE_VERSION}/* .

