#Rails Environment On Ubuntu 10.04 32bit (http://www.grandcloud.cn/)

Note: '#' is root exec, '$' is general user exec.

links:
  https://help.ubuntu.com/community/Git




##Install

###Base
    
    # apt-get update
    # cd ~
    # apt-get install sudo

###Install postgresql and configure

Links:
  http://www.54xue.com/man/PostgreSQL8.3/

Create user 'doc_share', passowrd is 'doc_share'

    # apt-get install postgresql libpq-dev
    # update-rc.d postgresql-8.4 defaults
    # /etc/init.d/postgresql-8.4 start
    # su postgres
    $ psql postgres
    postgres=# create language plpgsql;
    postgres=# alter user postgres password 'xxxxxx';
    postgres=# create user doc_share password 'doc_share';
    postgres=# create database doc_share_production;
    postgres=# grant all privileges on database doc_share_production to doc_share;
    postgres=# \q
    $ psql -d doc_share_production -U doc_share -W
    $ exit

if database created, error ' language "plpgsql" does not exist '

    $ createlang plpgsql doc_share_production

if error ' psql: FATAL:  Ident authentication failed for user "doc_share" '

    # vi /etc/postgresql/8.4/main/pg_hba.conf
        replace "ident" by either "md5"
    # /etc/init.d/postgresql-8.4 restart
    
    
###Install redis-server

    # apt-get install tcl8.5
    # wget http://redis.googlecode.com/files/redis-2.4.5.tar.gz
    # tar -zxvf redis-2.4.5.tar.gz  -C /usr/src
    # cd /usr/src/redis-2.4.5
    # make
    # make test
    # make install
    # cd utils
    # . install_server.sh
    # cd ~
    # update-rc.d redis_6379 defaults
    # /etc/init.d/redis_6379 start
    # redis-cli
    
Notice: If your could not connect to Redis at 127.0.0.1:6379, please chick `/etc/init.d/redis_6379` file
    
###Install imagemagick

    # apt-get install imagemagick libmagickwand-dev
    
###Install curl and git

    # apt-get install curl libcurl4-openssl-dev git-core

###Install coreseek

More information, see http://www.coreseek.cn/products-install/install_on_bsd_linux/

    # apt-get install make gcc g++ automake libtool mysql-client libmysqlclient15-dev libxml2-dev libexpat1-dev
    # wget http://www.coreseek.cn/uploads/csft/4.0/coreseek-4.1-beta.tar.gz
    # tar -zxvf coreseek-4.1-beta.tar.gz -C /usr/src/
    # cd /usr/src/coreseek-4.1-beta
    # cd mmseg-3.2.14
    # ./bootstrap
    # ./configure --prefix=/usr/local/mmseg3
    # make && make install
    # cd ..
    # cd csft-4.1
    # sh buildconf.sh
    # ./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg \
      --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ \
      --with-pgsql
    # make && make install
    # cd ..
    # cd testpack
    # cat var/test/test.xml
    # /usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc var/test/test.xml
    # /usr/local/coreseek/bin/indexer -c etc/csft.conf --all
    # /usr/local/coreseek/bin/search -c etc/csft.conf 网络搜索
    # cd ~
    
###Install other APT 

Solve install passenger error "PCRE could not be downloaded"
    
    # apt-get install libpcre3 libpcre3-dev
    
Solve install nokogiri error "libxslt is missing"

    # apt-get install libxslt-dev libxml2-dev 
    
###Install RVM
    
    # bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
    # source /etc/profile.d/rvm.sh
    # rvm notes
    # rvm install 1.9.3
    
Config and use RVM
    
    # echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"' >> ~/.bashrc
    # source ~/.bashrc
    # rvm --default use 1.9.3
    # gem sources --remove http://rubygems.org
    # gem sources -a http://ruby.taobao.org/
    # vi ~/.gemrc
      gem: --no-ri --no-rdoc

###Install bundler
  
    # gem i bundler --pre

###Install passenger

    # gem i passenger
    # rvmsudo passenger-install-nginx-module
    # wget https://raw.github.com/gist/1548664/53f6d7ccb9dfc82a50c95e9f6e2e60dc59e4c2fb/nginx
    # mv nginx /etc/init.d/
    # chmod +x /etc/init.d/nginx
    # update-rc.d nginx defaults

###Install gitolite(if you need)
    
    # useradd -m gitolite
    # passwd gitolite
    # su - gitolite
    $ ssh-keygen -C gitolite_admin
    $ cp .ssh/id_rsa.pub gitolite_admin.pub
    $ git clone git://github.com/sitaramc/gitolite
    $ gitolite/src/gl-system-install
    $ echo "PATH=$HOME/bin:$PATH" >> ~/.bashrc
    $ source ~/.bashrc
    $ gl-setup -q gitolite_admin.pub
    $ touch repositories/testing.git/git-daemon-export-ok # test git-daemon
    $ exit
    # cd ~
    
Install git-daemon and start it.

    # apt-get install git-daemon-run
    
service start

    # vi /etc/sv/git-daemon/run
    exec chpst --ugitdaemon \
      /usr/lib/git-core/git-daemon --verbose --base-path=/home/gitolite/repositories
    # sv restart git-daemon
    # git clone git://localhost/testing.git
    # sv stop git-daemon
    
init.d start
    
    # vi /etc/init.d/git-daemon
      see https://help.ubuntu.com/community/Git
    # chmod +x /etc/init.d/git-daemon
    # update-rc.d git-daemon defaults
    # /etc/init.d/git-daemon restart
    # git clone git://localhost/testing.git
    # rm -rf testing
    # /etc/init.d/git-daemon stop

Create rails app with gitolite
    
    # su - gitolite
    $ git clone gitolite@localhost:gitolite-admin
    $ cd gitolite-admin
    $ vi keydir/vkill.pub
      your id_rsa.pub content on __development machine__
    $ vi conf/gitolite.conf
        repo    doc_share
                RW+     = vkill
    $ git add keydir
    $ git commit -a -m "add repo doc_share and vkill key, change doc_share owner vkill"
    $ git push
    $ cd ~
    
Now, your can test it on __development machine__.

    # git clone gitolite@git.vkill.net:doc_share
    
If ok, your can modify your existed repository remote url and try git push it on __development machine__.
    
    # git remote set-url origin gitolite@git.vkill.net:doc_share
    # git remote show origin
    # git push origin master:master
    
###Clear tmp

    # mkdir /var/download
    # mv coreseek-4.1-beta.tar.gz redis-2.4.5.tar.gz /var/download



##Configure

###Create user railsapp, use it cap rails apps
  
Create

    # useradd -m railsapp
    # passwd railsapp
    # usermod -G sudo railsapp
    # su - railsapp

Config and use RVM, see Install RVM
    
Generate deploy ssh-key
After copy ~/.ssh/id_rsa.pub to (your github repository=>admin=>deploy keys) or other gitolite/gitosis
    
    $ ssh-keygen -C rails_apps_deploy
    $ exit
    
Add your id_rsa.pub content on __development machine__ to ~/.ssh/authorized_keys
    
    $ vi ~/.ssh/authorized_keys
    $ chmod 644 .ssh/authorized_keys
    
if your install gitolite on localhost, you can copy rails_apps_deploy.pub to gitolite-admin/keydir

    # cp /home/railsapp/.ssh/id_rsa.pub /home/gitolite/gitolite-admin/keydir/rails_apps_deploy.pub
    # chown gitolite:gitolite /home/gitolite/gitolite-admin/keydir/rails_apps_deploy.pub 
    # su - gitolite
    $ cd gitolite-admin
    $ vi conf/gitolite.conf
        repo    doc_share
                RW+     = vkill
                R       = rails_apps_deploy
    $ git add keydir
    $ git commit -a -m "add rails_apps_deploy read doc_share"
    $ git push
    $ exit
    # su - railsapp
    $ git clone gitolite@git.vkill.net:doc_share
    $ rm -rf doc_share
    $ exit
    
###Create rails apps directory
    
    # mkdir /var/rails_apps
    # chown railsapp:railsapp /var/rails_apps
  

###Add rails app to nginx

    # vi /opt/nginx/conf/nginx.conf
        ...
        http {
          ...
          include vhosts/*.conf;
          ...
    # mkdir /opt/nginx/conf/vhosts
    # vi /opt/nginx/conf/vhosts/doc_share.conf
        server {
          listen 80;
          server_name docshare.vkill.net;
          root /var/rails_apps/doc_share/current/public;
          passenger_enable on;
          rails_env production;
        }
    # /etc/init.d/nginx restart

##Development Machine cap rails app

more information, see Rails Root config/deploy.rb

###First, setup

on __development machine__

    # cap deploy:setup
    
on __production machine__, `# ssh railsapp@58.215.176.191`
    
    $ ls /var/rails_apps/doc_share
    $ cd /var/rails_apps/doc_share

create rails app config files

    $ mkdir shared/config
    $ vi shared/config/database.yml
        common: &common
          adapter: postgresql
          encoding: unicode
          pool: 5
          username: doc_share
          password: doc_share
        development:
          <<: *common
          database: doc_share_development
        test:
          <<: *common
          database: doc_share_test
        production:
          <<: *common
          database: doc_share_production
    $ vi shared/config/redis.yml
        development: localhost:6379
        test: localhost:6379
        production: localhost:6379
    $ vi shared/config/smtp_settings.yml
        common: &common
          address: smtp.qq.com
          port: 25
          domain: qq.com
          authentication: plain
          user_name: 137518792
          password: hyp123
        development:
          <<: *common
        test:
          <<: *common
        production:
          <<: *common

###Then, update code; generate base db data; restart passenger; start resque_worker, resque_scheduler, thinking_sphinx

on __development machine__

    # cap deploy:cold
    # cap deploy:db:seed
    # cap deploy:restart
    # cap deploy:start_workers
    # cap deploy:start_scheduler
    # cap deploy:start_thinking_sphinx

###Other deploy

    # cap deploy:stop_workers
    # cap deploy:stop_scheduler
    # cap deploy:stop_thinking_sphinx
    # cap deploy:restart_workers
    # cap deploy:restart_scheduler
    # cap deploy:restart_thinking_sphinx




.
