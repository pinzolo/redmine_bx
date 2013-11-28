# redmine_bx
[![Build Status](https://secure.travis-ci.org/pinzolo/redmine_bx.png)](http://travis-ci.org/pinzolo/redmine_bx)
[![Coverage Status](https://coveralls.io/repos/pinzolo/redmine_bx/badge.png)](https://coveralls.io/r/pinzolo/redmine_bx)

redmine_bx is a plugin for Redmine. This will reduce excel files in your projects.

## Installation

Execute follow commands at your Redmine directory.

#### 1. Clone to your Redmine's plugins directory:

```shell
$ git clone https://gihub.com/pinzolo/redmine_bx.git plugins/redmine_bx
```

#### 2. Install dependency gems:

```shell
$ bundle install
```

#### 3. Execute migration and deploy assets:

```shell
$ bundle exec rake redmine:plugins NAME=redmine_bx
```

#### 4. Restart your redmine

```shell
# In case of using passenger
$ touch tmp/restart.txt
```
