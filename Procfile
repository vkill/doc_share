
thin: bundle exec thin start -p 3000

resque_workers: bundle exec rake resque:workers QUEUE=* COUNT=2
resque_web: bundle exec resque-web --foreground --server thin --port 45678 --no-launch config/initializers/resque.rb

resque_scheduler: bundle exec rake resque:scheduler INITIALIZER_PATH=config/initializers/resque.rb



