module VersionHooksHelper
  def rails_version
    @rails_version ||= `bundle exec rails --version`.match(/[\d.]+$/).to_s
  end
end

Before '@requires-rails-version-42' do
  extend VersionHooksHelper
  if Gem::Version.new(rails_version) < Gem::Version.new('4.2')
    skip_this_scenario
  end
end
