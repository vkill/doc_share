#DocShare

V1.0

Doc Discover and Share


##Supported versions

* Postgresql should be installed and running

* Redis should be installed and running

* ImageMagick should be installed

* RVM should be installed and execute `rvm install 1.9.3` or `rvm install 1.9.2`


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
    > cp config/resque.yml.example config/resque.yml
    > cp config/smtp_settings.yml.example config/smtp_settings.yml

To run this rake, it init application

    > bundle exec rake app:dev:init

To run foreman

    > foreman start

To view resque web application

    > firefox http://127.0.0.1:45678/overview


##Use latest application

    > git pull
    > bundle install
    > bundle exec rake app:dev:reload
    > foreman start

