workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  @sidekiq_pid ||= spawn('bundle exec sidekiq') unless ENV['RACK_ENV'] == 'development'
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
