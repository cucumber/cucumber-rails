module Cucumber
  module Rails
    module Configuration
      extend self

      def self.configure(&block)
        instance_eval(&block)
      end

      private

        def set(key, value)
          config[key] = value
        end

        def config
          @config ||= Hash.new
        end

        def method_missing(sym, *args)
          if sym.to_s =~ /(.+)=$/
            config[$1] = args.first
          else
            config[sym]
          end
        end
    end
  end
end
