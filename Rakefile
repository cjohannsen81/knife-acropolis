require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rubocop/rake_task'

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

# lint the project
desc 'Run robocop linter'
task lint: [:rubocop]
