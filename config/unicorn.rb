rails_env = "development"
app_name = "geoauth"
basedir = "/var/www/app/rails/#{rails_env}/#{app_name}"

worker_processes rails_env == 'production' ? 16 : 4

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "#{basedir}"


# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "#{basedir}/tmp/sockets/unicorn.#{app_name}.sock", :backlog => 64
# listen 54018, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 10

# feel free to point this anywhere accessible on the filesystem
pid "#{basedir}/tmp/pids/unicorn.pid"

stderr_path "#{basedir}/log/#{app_name}.stderr.log"
stdout_path "#{basedir}/log/#{app_name}.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  puts "#{server.pid}"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Error sending QUIT"
    end
  end
  sleep 1
end

after_fork do |server, worker|
  process_pid = worker.nr

  child_pid = server.config[:pid].sub('.pid', ".#{process_pid}.pid")
  File.open(child_pid, "w") do |f|
    f.puts Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection rails_env.to_sym

end
