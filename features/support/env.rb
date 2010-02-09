require 'rubygems'

gem 'rspec', '1.3.0'
require 'spec'

Before do
  Dir.mkdir("tmp") unless Dir.exist?("tmp")
  system "rm -rf tmp/*"
end