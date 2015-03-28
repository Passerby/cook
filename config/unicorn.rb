worker_processes 1

app_root = File.expand_path('../..', __FILE__)
# deploy_to = '/mnt/data/www/lytx/qiyejifen/'
unicorn_pid = '/tmp/cook.unicorn.pid'

# Listen on fs socket for better performance
listen '/tmp/unicorn_qiyejifen.sock', backlog: 64

# Nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# App PID
pid "#{ unicorn_pid }"
# Production specific settings
if ENV['RAILS_ENV'] == 'production'
  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up.
  listen '19206', tcp_nopush: false
  # working_directory "#{ deploy_to }current"

  # feel free to point this anywhere accessible on the filesystem user 'spree'
  # shared_path = "#{ deploy_to }shared"

  # stderr_path "#{ shared_path }/log/unicorn.stderr.log"
  # stdout_path "#{ shared_path }/log/unicorn.stdout.log"
end

# To save some memory and improve performance
# preload_app true
# GC.respond_to?(:copy_on_write_friendly=) and
#   GC.copy_on_write_friendly = true

# Force the bundler gemfile environment variable to
# reference the Сapistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(app_root, 'Gemfile')
end

before_fork do |server, worker|
  # 参考 http://unicorn.bogomips.org/SIGNALS.html
  # 使用USR2信号，以及在进程完成后用QUIT信号来实现无缝重启
  old_pid = "#{ unicorn_pid }.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
      puts "Kill OLD BIN ERROR!!!"
    end
  end

  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end
