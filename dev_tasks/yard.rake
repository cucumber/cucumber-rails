require 'yard'
require 'yard/rake/yardoc_task'

YARD::Templates::Engine.register_template_path(File.expand_path(File.join(File.dirname(__FILE__), 'yard')))
YARD::Rake::YardocTask.new(:yard) do |t|
  t.options = %w{--no-private --title Cucumber-Rails}
  t.files = %w{lib - README.md History.md LICENSE}
end

desc "Push yardoc to http://cukes.info/cucumber-rails/api/#{CUCUMBER_RAILS_VERSION}"
task :push_yard => :yard do
  sh("tar czf tmp/api-#{CUCUMBER_RAILS_VERSION}.tgz -C doc .")
  sh("scp tmp/api-#{CUCUMBER_RAILS_VERSION}.tgz cukes.info:/var/www/cucumber-rails/api")
  sh("ssh cukes.info 'cd /var/www/cucumber-rails/api && rm -rf #{CUCUMBER_RAILS_VERSION} && mkdir #{CUCUMBER_RAILS_VERSION} && tar xzf api-#{CUCUMBER_RAILS_VERSION}.tgz -C #{CUCUMBER_RAILS_VERSION} && rm -f latest && ln -s #{CUCUMBER_RAILS_VERSION} latest'")
end

task :release => :push_yard