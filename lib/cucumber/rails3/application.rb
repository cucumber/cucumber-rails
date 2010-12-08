require 'rails/application'

# Make sure the ActionDispatch::ShowExceptions middleware is always enabled,
# regardless of what is in config/environments/test.rb
# Instead we are overriding ActionDispatch::ShowExceptions to be able to
# toggle whether or not exceptions are raised.
class Rails::Application
  alias __cucumber_orig_initialize__ initialize!
  
  def initialize!
    ad = config.action_dispatch
    def ad.show_exceptions
      true
    end
    __cucumber_orig_initialize__
  end
end
