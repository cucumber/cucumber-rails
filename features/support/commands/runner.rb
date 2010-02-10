class Commands
  class Runner
    attr_reader :command_history

    def initialize(directory, ruby_version, rails_version)
      @directory = directory
      @ruby_version = ruby_version
      @rails_version = rails_version
      @command_history = []
    end

    def rails(options)
      rvm("rails _#{@rails_version}_ #{options}")
    end

    def rvm(command)
      run_and_log("rvm #{@ruby_version}%cucumber-rails -S #{command}")
    end

    def chmod(*args)
      in_runner_dir { File.chmod(*args) }
    end

    def files
      in_runner_dir { Dir["**/*"] }
    end

    def file(filename)
      in_runner_dir { File.new(filename, "r") }
    end

    def open_file(filename, mode, &block)
      in_runner_dir { File.open(filename, mode, &block) }
    end

    private

    def run_and_log(command)
      in_runner_dir do
        @command_history << command
        `#{command}`
      end
    end

    def in_runner_dir
      Dir.chdir(@directory) { yield }
    end
  end
end
