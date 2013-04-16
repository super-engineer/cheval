require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"

set :application, "cheval"
set :repository,  "git@github.com:super-engineer/cheval.git"
set :scm, :git
set :server_name, "50.57.71.208"
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
      <VirtualHost *:8080>
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