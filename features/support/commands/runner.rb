require 'tempfile'

class Commands
  class Runner
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
      last_stdout = ''
      stderr_file = Tempfile.new('cucumber-rails')
      stderr_file.close
      in_runner_dir do
        mode = RUBY_VERSION =~ /^1\.9/ ? {:external_encoding=>"UTF-8"} : 'r'
        IO.popen("#{command} 2> #{stderr_file.path}", mode) do |io|
          last_stdout = io.read
        end
      end
      last_exit_status = $?.exitstatus
      last_stderr = IO.read(stderr_file.path)

      if last_exit_status != 0
        raise "ERROR:#{last_exit_status}:command\n\n#{last_stdout}\n--------------\n#{last_stderr}"
      end
    end

    def in_runner_dir
      Dir.chdir(@directory) { yield }
    end
  end
end
