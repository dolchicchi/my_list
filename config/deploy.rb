lock '3.17.0'

set :application, 'my_list'

set :repo_url, 'git@github.com:dolchicchi/my_list.git'

set :linked_dirs,
    fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',
                                 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.6.5'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/aws_key_pair.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
