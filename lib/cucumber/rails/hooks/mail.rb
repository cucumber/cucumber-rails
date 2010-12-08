if defined?(ActionMailer::Base)
  Before do
    ActionMailer::Base.deliveries = []
  end
end
