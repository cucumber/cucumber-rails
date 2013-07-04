ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
end
