module Cucumber
  module Rails
    module Capybara
      module SelectDatesAndTimes
        def select_date(field, options = {})
          date        = Date.parse(options[:with])
          base_dom_id = get_base_dom_id_from_label_tag(field)

          find(:xpath, "//select[@id='#{base_dom_id}_1i']").select(date.year.to_s)
          find(:xpath, "//select[@id='#{base_dom_id}_2i']").select(date.strftime('%B'))
          find(:xpath, "//select[@id='#{base_dom_id}_3i']").select(date.day.to_s)
        end
      
        def select_time(field, options = {})
          time        = Time.zone.parse(options[:with])
          base_dom_id = get_base_dom_id_from_label_tag(field)

          find(:xpath, "//select[@id='#{base_dom_id}_4i']").select(time.hour.to_s.rjust(2, '0'))
          find(:xpath, "//select[@id='#{base_dom_id}_5i']").select(time.min.to_s.rjust(2,  '0'))
        end
      
        def select_datetime(field, options = {})
          select_date(field, options)
          select_time(field, options)
        end

        private

        # @example "event_starts_at_"
        def get_base_dom_id_from_label_tag(field)
          find(:xpath, "//label[contains(., '#{field}')]")['for'].gsub(/(_1i)$/, '')
        end
      end
    end
  end
end

World(::Cucumber::Rails::Capybara::SelectDatesAndTimes)

When /^(?:|I )select "([^"]+)" as the "([^"]+)" time$/ do |time, selector|
  select_time(selector, :with => time)
end

When /^(?:|I )select "([^"]+)" as the "([^"]+)" date$/ do |date, selector|
  select_date(selector, :with => date)
end

When /^(?:|I )select "([^"]+)" as the "([^"]+)" date and time$/ do |datetime, selector|
  select_datetime(selector, :with => datetime)
end
