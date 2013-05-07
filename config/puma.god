ROOT = "/var/www/app/rails/development/geoauth"

God.pid_file_directory = "#{ROOT}/tmp/pids"


# rails_env = ENV['RAILS_ENV'] || 'production'
rails_env = ENV['RAILS_ENV'] || 'development'
rails_root = ENV['RAILS_ROOT'] || ROOT
 

God::Contacts::Email.defaults do |d|
  d.from_email = 'god@dotgee.net'
  d.from_name = 'God Watcher'
  d.delivery_method = :sendmail
end

God.contact(:email) do |c|
  c.name = 'xymox'
  c.group = 'admins'
  c.to_email = 'philippe@dotgee.fr'
end

God.watch do |w|
  w.name = "puma"
  w.interval = 10.seconds # default

  # unicorn needs to be run from the rails root
  w.start = "cd #{rails_root} && bundle exec puma -b unix://#{rails_root}/tmp/sockets/puma.sock -q --pidfile #{rails_root}/tmp/pids/puma.pid"

  # QUIT gracefully shuts down workers
  w.stop = "kill -TERM `cat #{rails_root}/tmp/pids/puma.pid`"

  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{rails_root}/tmp/pids/puma.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{rails_root}/tmp/pids/puma.pid"

  #w.uid = 'xymox'
  #w.gid = 'rvm'

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

