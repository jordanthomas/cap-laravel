server "[SERVER]", :web, :app, :db, primary: true

set :application, "[APPLICATION]"
set :user, "[DEPLOY USER]"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, "git"
set :repository, "[RESPOSITORY URL]"
set :branch, "master"

ssh_options[:forward_agent] = true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :finalize_update, :except => { :no_release => true } do ; end

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/application/config"
    put File.read("application/config/database.php.example"), "#{shared_path}/application/config/database.php"
  end

  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/application/config/database.php #{release_path}/application/config/database.php"
  end

  after "deploy:finalize_update", "deploy:symlink_config"

  task :symlink_logs, roles: :app do
    run "ln -s #{shared_path}/log #{release_path}/storage/logs"
  end

  after "deploy:finalize_update", "deploy:symlink_logs"

  task :start do ; end
  task :stop do ; end
  task :restart do ; end
end
