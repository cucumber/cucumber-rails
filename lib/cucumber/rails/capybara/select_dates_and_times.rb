module Cucumber
  module Rails
    module Capybara
      module SelectDatesAndTimes
        def select_date(field, options = {})
          date = Date.parse(options[:with])
          find(:xpath, XPath::HTML.select("#{field}_1i")).find(:xpath, XPath::HTML.option(date.year.to_s)).select_option
          find(:xpath, XPath::HTML.select("#{field}_2i")).find(:xpath, XPath::HTML.option(date.strftime('%B'))).select_option
          find(:xpath, XPath::HTML.select("#{field}_3i")).find(:xpath, XPath::HTML.option(date.day.to_s)).select_option
        end

        def select_time(field, options = {})
          time = Time.parse(options[:with])
          find(:xpath, XPath::HTML.select("#{field}_4i")).find(:xpath, XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
          find(:xpath, XPath::HTML.select("#{field}_5i")).find(:xpath, XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
        end

        def select_datetime(field, options = {})
          select_date(field, options)
          select_time(field, options)
        end
      end
    end
  end
end

World(::Cucumber::Rails::Capybara::SelectDatesAndTimes)

When /^(?:|I )select "([^"]*)" as the "([^"]*)" time$/ do |time, selector|
  select_time(selector, :with => time)
end

When /^(?:|I )select "([^"]*)" as the "([^"]*)" date$/ do |date, selector|
  select_date(selector, :with => date)
end

When /^(?:|I )select "([^"]*)" as the "([^"]*)" date and time$/ do |datetime, selector|
  select_datetime(selector, :with => datetime)
end
