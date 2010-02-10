class Commands
  # TODO merge with Runner

  # TODO remove duplication
  class Rails2App
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

  class Rails3App
    def initialize(app_name, rails_version, runner)
      @app_name = app_name
      @rails_version = rails_version
      @runner = runner
      prepare_app
    end

    def rails(options)
      @runner.rails(options)
    end

    def files
      @runner.files
    end

    def file(filename)
      @runner.file(filename)
    end

    private

    def prepare_app
      fix_script_permissions
      add_cucumber_rails_to_gemfile
    end

    def fix_script_permissions
      @runner.chmod(0755, "script/rails")
    end

    def add_cucumber_rails_to_gemfile
      @runner.open_file("Gemfile", "a") { |gemfile| gemfile << %Q{\ngem "cucumber-rails", :require => nil\n} }
    end
  end
end