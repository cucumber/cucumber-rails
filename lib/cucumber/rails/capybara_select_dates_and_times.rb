module Cucumber
  module Rails
    module CapybaraSelectDatesAndTimes
      def select_date(field, options = {})
        date = Date.parse(options[:with])
        within(:xpath, Capybara::XPath.fieldset(field).append(%Q{//p[label[contains(., "#{field}")]]})) do
          find(:xpath, '//select[contains(@id, "_1i")]').select(date.year)
          find(:xpath, '//select[contains(@id, "_2i")]').select(date.strftime('%B'))
          find(:xpath, '//select[contains(@id, "_3i")]').select(date.day)
        end
      end
      
      def select_time(field, options = {})
        time = Time.parse(options[:with])
        within(:xpath, Capybara::XPath.fieldset(field).append(%Q{//p[label[contains(., "#{field}")]]})) do
          find(:xpath, '//select[contains(@id, "_4i")]').select(time.hour.to_s.rjust(2,'0'))
          find(:xpath, '//select[contains(@id, "_5i")]').select(time.min.to_s.rjust(2,'0'))
        end
      end
      
      def select_datetime(field, options = {})
        select_date(field, options)
        select_time(field, options)
      end
    end
  end
end

World(Cucumber::Rails::CapybaraSelectDatesAndTimes)

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, selector|
  select_time(selector, :with => time)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, selector|
  select_date(selector, :with => date)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, selector|
  select_datetime(selector, :with => datetime)
end
