desc "Prepare and run the features"
task :cucumber => %w[ cucumber:prepare cucumber:run ]

namespace :cucumber do
  desc "Run the Cucumber features without preparing RVM"
  task :run do
    system "cucumber"
  end

  desc "Prepare RVM environments for Cucumber"
  task :prepare do
    system "rvm 1.8.7%cucumber-rails -S rake install"
    system "rvm 1.9.1%cucumber-rails -S rake install"
  end
end
