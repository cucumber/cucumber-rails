# frozen_string_literal: true

if defined?(ActionMailer)
  Before do
    ActionMailer::Base.deliveries = []
  end
end
