geoauth_root = "/var/www/app/rails/development/geoauth"
geoauth_rails_env = 'development'
 
God.watch do |w|
  w.name = "geoauth_puma"
  w.interval = 10.seconds # default

  w.log = "#{geoauth_root}/log/god.log"

  # unicorn needs to be run from the rails root
  w.start = "cd #{geoauth_root} && bundle exec puma -b unix://#{geoauth_root}/tmp/sockets/puma.sock -q --pidfile #{geoauth_root}/tmp/pids/puma.pid -e #{geoauth_rails_env}"

  # QUIT gracefully shuts down workers
  w.stop = "kill -TERM `cat #{geoauth_root}/tmp/pids/puma.pid`"

  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{geoauth_root}/tmp/pids/puma.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{geoauth_root}/tmp/pids/puma.pid"

  # w.uid = 'xymox'
  # w.gid = 'rvm'

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

