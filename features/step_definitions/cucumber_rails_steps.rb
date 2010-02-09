# TODO ~/.bash_profile

Given /^I'm using Ruby (.*) and Rails (.*)$/ do |ruby_version, rails_version|
  @commands = Commands.new(ruby_version, rails_version)
end

Given /^a Rails app "(.*)"$/ do |app_name|
  @rails_app = @commands.new_rails_app(app_name)
end

When /^I run "script\/(.*)" in the app$/ do |command|
  @rails_app.script(command)
end

Spec::Matchers.define :have_files do |expected_files|
  match do |rails_app|
    actual_files = rails_app.files
    @missing_files = expected_files - actual_files
    @missing_files.empty?
  end
  
  failure_message_for_should do |expected_files|
    "Rails app was missing these files:\n" + @missing_files.map { |file| "  #{file}" }.join("\n")
  end
end

Then /^I will have the following new files and directories$/ do |table|
  expected_files = table.hashes.collect { |row| row[:name] }
  @rails_app.should have_files(expected_files)
end
