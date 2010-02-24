require 'cucumber/rails/rvm'

namespace :rvm do
  desc 'Install all gemsets'
  task :install_gems do
    Cucumber::Rails::Rvm.each do |rvm|
      rvm.install_gems
    end
  end
end