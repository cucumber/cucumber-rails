require "xpath" # XPath is a separate gem now

module Cucumber
  module Rails
    module Capybara
      module SelectDatesAndTimes
        def select_date (date, options = {})
          date = Date.parse(date)

          # lookup id prefix by label
          id_prefix = id_prefix_for(options[:label])

          # select the appropriate date values
          select date.year, :from => "#{id_prefix}_1i"
          select date.strftime('%B'), :from => "#{id_prefix}_2i"
          select date.day, :from => "#{id_prefix}_3i"
        end

        def select_time (time, options = {})
          time = Time.parse(time)

          # lookup id prefix by label
          id_prefix = id_prefix_for(options[:label])

          # select the appropriate time values
          select(time.hour.to_s.rjust(2, '0'), :from => "#{id_prefix}_4i")
          select(time.min.to_s.rjust(2, '0'), :from => "#{id_prefix}_5i")
        end

        def select_datetime (datetime, options = {})
          select_date(datetime, options)
          select_time(datetime, options)
        end

        protected
        def id_prefix_for (label_text)
          # lookup label by contents
          # determine the datetime fields' id prefix from the label's @for attribute
          find(:xpath, %Q{//form/*/label[contains(text(), "#{label_text}")]})[:for]
        end
      end
    end
  end
end

World(Cucumber::Rails::Capybara::SelectDatesAndTimes)

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, selector|
  select_time(time, :label => selector)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, selector|
  select_date(date, :label => selector)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, selector|
  select_datetime(datetime, :label => selector)
end