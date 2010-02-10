class Commands
  def initialize(ruby_version, rails_version)
    @ruby_version = ruby_version
    check_version("Ruby", @ruby_version, %w[ 1.8.7  1.9.1 ])

    @rails_version = rails_version
    check_version("Rails", @rails_version, %w[ 2.3.5  3.0.0.beta ])

    @runner = Runner.new("tmp", @ruby_version, @rails_version)
  end

  def new_rails_2_app(app_name)
    @runner.rails("#{app_name}")
    runner = Runner.new("tmp/#{app_name}", @ruby_version, @rails_version)
    Rails2App.new(app_name, @rails_version, runner)
  end

  # TODO remove duplication with #new_rails_2_app
  def new_rails_3_app(app_name)
    @runner.rails("#{app_name}")
    runner = Runner.new("tmp/#{app_name}", @ruby_version, @rails_version)
    Rails3App.new(app_name, @rails_version, runner)
  end

  private

  def check_version(command, version, allowed_versions)
    raise %Q{Invalid #{command} version "#{version}"} unless allowed_versions.include?(version)
  end
end