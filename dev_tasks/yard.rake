require 'yard'
require 'yard/rake/yardoc_task'

SITE_DIR = File.expand_path(File.dirname(__FILE__) + '/../cucumber.github.com')
API_DIR = File.join(SITE_DIR, 'api', 'cucumber-rails', 'ruby', 'yardoc')

namespace :api do
  file :dir do
    unless File.directory?(SITE_DIR)
      raise "You need to git clone git@github.com:cucumber/cucumber.github.com.git #{SITE_DIR}"
    end
    sh('git pull origin master')
    mkdir_p API_DIR
  end

  template_path = File.expand_path(File.join(File.dirname(__FILE__), 'yard'))
  YARD::Templates::Engine.register_template_path(template_path)
  YARD::Rake::YardocTask.new(:yard) do |yard|
    dir = API_DIR
    mkdir_p dir
    yard.options = ["--out", dir]
  end
  task :yard => :dir

  task :release do
    Dir.chdir(SITE_DIR) do
      sh('git add .')
      sh("git commit -m 'Update API docs for cucumber-rails v#{cucumber-rails::VERSION}'")
      sh('git push origin master')
    end
  end

  desc "Generate YARD docs for Cucumber-Rails' API"
  task :doc => [:yard, :release]
end
