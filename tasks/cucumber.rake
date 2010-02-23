require 'cucumber/rails/rvm'

desc "Prepare and run the features"
task :cucumber => %w[ cucumber:prepare cucumber:run ]

namespace :cucumber do
  desc "Run the Cucumber features without preparing RVM"
  task :run do
    system "cucumber --tags ~@wip"
  end

  desc "Prepare RVM environments for Cucumber"
  task :prepare do
    Cucumber::Rails::Rvm.each do |rvm|
      rvm.rvm('-S rake install')
    end
  end
end
