require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"

set :application, "cheval"
set :repository,  "git@github.com:super-engineer/cheval.git"
set :scm, :git
set :server_name, "chevalmumbai.com"
set :user, "webadmin"
set :runner, "webadmin"
set :password, "Qwerty123!"
set :deploy_via, :export
set :ssh_options, { :forward_agent => true }
set :branch, "master"
set :base_path, "/home/webadmin/sites"
set :deploy_to, "/home/webadmin/sites/#{application}"
set :apache_site_folder, "/etc/apache2/sites-enabled"
set :migrate_target, :current
set :migrate_env, ""
set :db_user, "root"
set :db_pass, "Qwerty123!"
set :stage, :production

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_ruby_string, "ruby-1.9.3-p362"
set :rvm_type, :user

role :web, server_name
role :app, server_name
role :db,  server_name, :primary => true
set :whenever_command, "bundle exec whenever"

ssh_options[:paranoid] = false
default_run_options[:pty] = true

# before 'deploy:setup', 'rvm:install_rvm'
# before 'deploy:setup', 'rvm:install_ruby'
after "deploy:setup", "init:set_permissions"
after "deploy:setup", "init:create_database"
after "deploy:setup", "init:database_yml"
after "deploy:setup", "init:create_vhost"
after "deploy:update_code", "config:copy_shared_configurations"
after "deploy:rollback:revision", "bundler:install"
#after "deploy:update_code", "bundler:bundle_new_release"

# Overrides for Phusion Passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
    sudo "/etc/init.d/apache2 restart"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end

# Configuration Tasks
namespace :config do
  desc "copy shared configurations to current"
  task :copy_shared_configurations, :roles => [:app] do
    %w[database.yml].each do |f|
      run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end
end

namespace :init do

  desc "setting proper permissions for deploy user"
  task :set_permissions do
    sudo "chown -R #{user} #{base_path}/#{application}"
  end

  desc "create mysql db"
  task :create_database do
    #create the database on setup
    set :db_user, Capistrano::CLI.ui.ask("database user: ") unless defined?(:db_user)
    set :db_pass, Capistrano::CLI.password_prompt("database password: ") unless defined?(:db_pass)
    run "echo \"CREATE DATABASE #{application}_production\" | mysql -u #{db_user} --password=#{db_pass}"
  end

  desc "enable site"
  task :enable_site do
    sudo "ln -nsf #{shared_path}/config/apache_site.conf #{apache_site_folder}/#{application}"

  end

  desc "create database.yml"
  task :database_yml do
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("database password: ")
    database_configuration = %(
      production:
        adapter: mysql2
        encoding: utf8
        database: #{application}_production
        host: localhost
        username: #{db_user}
        password: #{db_pass}
        socket: /var/run/mysqld/mysqld.sock
      )
    run "mkdir -p #{shared_path}/config"
    put database_configuration, "#{shared_path}/config/database.yml"
  end


  desc "create vhost file"
  task :create_vhost do

    vhost_configuration = %(
      <VirtualHost *:80>
        ServerName #{server_name}
        DocumentRoot #{base_path}/#{application}/current/public
        <Directory #{base_path}/#{application}/current/public>
           AllowOverride all
           Options -MultiViews
        </Directory>
        <LocationMatch "^/assets/.*$">
          Header unset ETag
          FileETag None
          ExpiresActive On
          ExpiresDefault "access plus 1 year"
        </LocationMatch>
        PassengerMinInstances 1
      </VirtualHost>
    )
    put vhost_configuration, "#{shared_path}/config/apache_site.conf"
  end

end

namespace :db do
  desc "Populates the production database"
  task :populate do
    puts "\n\n=== Populating production database ===\n\n"
    run "cd #{current_path}; rake db:populate RAILS_ENV=production"
  end
end

namespace :log do
 desc "Tail production log file"
 task :tail, :roles => :app do
   run "tail -n 500 -f #{shared_path}/log/production.log" do |channel, stream, data|
     # this catches the INT signal and avoids the ugly capistrano error on CTRL+C
     trap("INT") { puts 'Interupted'; exit 0; }
     # this is to have a cleaner output
     puts "#{channel[:domain]}: #{data}"
     break if stream == :err
   end
 end
end


namespace :sync do
  require 'yaml'
  require 'pathname'

  desc "Creates the sync dir in shared path. The sync directory is used to keep backups of database dumps and archives from synced directories. This task will be called on 'deploy:setup'"
  task :setup do
    run "cd #{shared_path}; mkdir sync"
  end

  namespace :down do
    desc "Syncs the database and declared directories from the selected multi_stage environment to the local development environment. This task simply calls both the 'sync:down:db' and 'sync:down:fs' tasks."
    task :default do
      db and fs
    end

    desc "Syncs database from the selected mutli_stage environement to the local develoment environment. The database credentials will be read from your local config/database.yml file and a copy of the dump will be kept within the shared sync directory. The amount of backups that will be kept is declared in the sync_backups variable and defaults to 5."
    task :db, :roles => :db, :only => { :primary => true } do
      filename = "database.#{stage}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"
      on_rollback { delete "#{shared_path}/sync/#{filename}" }
      # Remote DB dump
      username, password, database, host = remote_database_config(stage)
      hostcmd = host.nil? ? '' : "-h #{host}"
      puts "hostname was #{host}"
      puts "database was #{database}"
      run "mysqldump -u #{username} --password='#{password}' #{hostcmd} #{database} | bzip2 -9 > #{shared_path}/sync/#{filename}" do |channel, stream, data|
        puts data
      end
      purge_old_backups "database"
      # Download dump
      download "#{shared_path}/sync/#{filename}", filename
      # Local DB import
      username, password, database = database_config('development')
      system "bzip2 -d -c #{filename} | mysql -u #{username} --password='#{password}' #{database}"#{}"; rm -f #{filename}"
      logger.important "sync database from the stage '#{stage}' to local finished"
    end

    desc "Sync declared directories from the selected multi_stage environment to the local development environment. The synced directories must be declared as an array of Strings with the sync_directories variable. The path is relative to the rails root."
    task :fs, :roles => :web, :once => true do
      server, port = host_and_port
      Array(fetch(:sync_directories, [])).each do |syncdir|
        unless File.directory? "#{syncdir}"
          logger.info "create local '#{syncdir}' folder"
          Dir.mkdir "#{syncdir}"
        end
        logger.info "sync #{syncdir} from #{server}:#{port} to local"
        destination, base = Pathname.new(syncdir).split
        system "rsync --verbose --archive --compress --copy-links --delete --stats --rsh='ssh -p #{port}' #{user}@#{server}:#{current_path}/#{syncdir} #{destination.to_s}"
      end
      logger.important "sync filesystem from the stage '#{stage}' to local finished"
    end
  end

  def database_config(db)
    database = YAML::load_file('config/database.yml')
    return database["#{db}"]['username'], database["#{db}"]['password'], database["#{db}"]['database'], database["#{db}"]['host']
  end

  #
  # Reads the database credentials from the remote config/database.yml file
  # +db+ the name of the environment to get the credentials for
  # Returns username, password, database
  #
  def remote_database_config(db)
    remote_config = capture("cat #{shared_path}/config/database.yml")
    database = YAML::load(remote_config)
    return database["#{db}"]['username'], database["#{db}"]['password'], database["#{db}"]['database'], database["#{db}"]['host']
  end

  #
  # Returns the actual host name to sync and port
  #
  def host_and_port
    return roles[:web].servers.first.host, ssh_options[:port] || roles[:web].servers.first.port || 22
  end

  #
  # Purge old backups within the shared sync directory
  #
  def purge_old_backups(base)
    count = fetch(:sync_backups, 5).to_i
    backup_files = capture("ls -xt #{shared_path}/sync/#{base}*").split.reverse
    if count >= backup_files.length
      logger.important "no old backups to clean up"
    else
      logger.info "keeping #{count} of #{backup_files.length} sync backups"
      delete_backups = (backup_files - backup_files.last(count)).join(" ")
      try_sudo "rm -rf #{delete_backups}"
    end
  end
end
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end