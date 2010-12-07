ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
  include ActiveSupport::Rescuable
  rescue_from ::Exception, :with => lambda {|e| raise e unless ActionController::Base.allow_rescue}
end
