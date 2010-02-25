Given /^I symlink this repo to "([^\"]*)"$/ do |target|
  source = File.expand_path('../../..', __FILE__)
  in_current_dir do
    target = File.expand_path(target)
    FileUtils.ln_s(source, target)
  end
end
