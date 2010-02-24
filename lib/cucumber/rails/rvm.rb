module Cucumber
  module Rails
    # This class is only used for testing Cucumber-Rails
    class Rvm #:nodoc:
      RVMS = YAML.load_file(File.dirname(__FILE__) + '/../../../rvm.yml')
      
      class << self
        def each(&proc)
          RVMS['rubies'].each do |ruby_name, ruby_version|
            gems = RVMS['gems']
            RVMS['rails_gems'].each do |rails_version, rails_gems|
              proc.call(new(ruby_name, rails_version, gems + rails_gems, nil))
            end
          end
        end
      end

      def initialize(ruby_name, rails_version, gems_with_version, world)
        @ruby_version, @rails_version, @gems_with_version, @world = RVMS['rubies'][ruby_name], rails_version, gems_with_version, world
        raise "NO RUBY VERSION FOUND FOR #{ruby_name}. Check your rvms.yml" if @ruby_version.nil?
      end

      begin
        require 'aruba/api'
        include Aruba::Api
      rescue LoadError => ignore
        STDOUT.puts "The aruba gem ins not installed. That's ok." 
        def run(cmd)
          system(cmd)
        end
      end

      def rvm(cmd)
        rvm_cmd = "rvm #{@ruby_version}%cucumber-rails-#{@rails_version} #{cmd}"
        if @world
          @world.announce(rvm_cmd)
        else
          puts(rvm_cmd)
        end
        run(rvm_cmd)
        raise "STDOUT:\n#{@last_stdout}\nSTDERR:\n#{@last_stderr}" if @last_exit_status && @last_exit_status != 0
      end

      def rails(args)
        rvm("-S rails _#{@rails_version}_ #{args}")
      end

      def rails_create(name)
        rails(name)
        cd(name)
        if @rails_version =~ /^3\./
          @world.announce('Adding gems to Gemfile')
          append_to_file("Gemfile", 'gem "cucumber-rails"')
          append_to_file("Gemfile", 'gem "capybara" , :git => "git://github.com/aslakhellesoy/capybara.git"')
          append_to_file("Gemfile", 'gem "database_cleaner"')
        end
      end

      def install_gems
        @gems_with_version.each do |gem_with_version|
          rvm("-S gem install #{gem_with_version}")
        end
      end

      def new_rails_app(name)
        RailsApp.new(name, self)
      end
    end
    
    class RailsApp
      def initialize(name, rvm)
        @name, @rvm = name, rvm
        create!
      end
      
      def create!
        @rvm.rails_create(@name)
      end

      def run(args)
        @rvm.rvm("-S #{args}")
      end

      def rails(args)
        @rvm.rails(args)
      end

      def files
        @rvm.in_current_dir { Dir["**/*"] }
      end

      def file(filename)
        @rvm.in_current_dir { File.new(filename, "r") }
      end
    end
  end
end