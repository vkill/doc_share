#DocShare

V1.0

Doc Discover and Share


##Supported versions

* Postgresql should be installed and running

* Redis should be installed and running

* Cronie should be installed and running

* ImageMagick should be installed

* coreseek 4.1 should be installed, read http://www.coreseek.cn/products-install/install_on_bsd_linux/.
    Note:
        configure csft-4.1 add `--with-pgsql` option.
        `/usr/local/coreseek/bin/indexer` and `/usr/local/coreseek/bin/searchd` should be existed.
        `/usr/local/mmseg3/etc/uni.lib` should be existed.

* Git should be installed

* RVM should be installed and execute `rvm install 1.9.3`

* Openssh

* Sudo


##Make application run on your local

Clone the application from git server

    > git clone git@github.com:vkill/doc_share.git

Enter the app directory

    > cd doc_share

To install bendler and run bundle

    > gem install bundler --pre
    > bundle install

Copy yaml configuration files from example, after your need edit it.

    > cp config/database.yml.example config/database.yml
    > cp config/redis.yml.example config/redis.yml
    > cp config/smtp_settings.yml.example config/smtp_settings.yml

To run this rake, it init application
    > bundle exec rake db:create:all
    > bundle exec rake app:dev:init

Processing your Index
    
    > bundle exec rake ts:index

To run foreman

    > foreman start
    # Start searchd, like this `/usr/bin/sphinx-searchd --pidfile --config /doc_share/config/development.sphinx.conf`

If foreman error, to run killall ruby and rerun `foreman start`

    > killall ruby
    > killall sphinx-searchd

To view resque web application

    > firefox http://127.0.0.1:45678/overview

To run test

    > guard

Use this user signin and test

    login: vkill  or  vkill.net@gmail.com
    password: 123456


##Use latest application

Enter the app directory, and run

    > git pull
    > bundle install
    > bundle exec rake app:dev:reload
    > bundle exec rake ts:index
    > foreman start

##Production

Init production
    
    > bundle exec rake app:production:init RAILS_ENV=production
