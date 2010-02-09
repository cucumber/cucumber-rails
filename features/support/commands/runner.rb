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
      run_and_log("rvm #{@ruby_version} -S #{command}")
    end

    def files
      in_runner_dir do
        Dir["**/*"]
      end
    end

    private

    def run_and_log(command)
      in_runner_dir do
        @command_history << command
        `#{command}`
      end
    end

    def in_runner_dir
      Dir.chdir(@directory) do
        yield
      end
    end
  end
end
