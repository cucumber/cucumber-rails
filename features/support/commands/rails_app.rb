class Commands
  class RailsApp
    def initialize(app_name, rails_version, runner)
      @app_name = app_name
      @rails_version = rails_version
      @runner = runner
    end

    def script(options)
      @runner.rvm("script/#{options}")
    end

    def files
      @runner.files
    end

    def file(filename)
      @runner.file(filename)
    end
  end
end