module Cucumber
  module Rails
    module Capybara
      # This module defines methods for selecting dates and times
      module SelectDatesAndTimes
        # Select a Rails date. Options has must include :from => +label+
        def select_date(date, options)
          date        = Date.parse(date)
          base_dom_id = get_base_dom_id_from_label_tag(options[:from])

          find(:xpath, ".//select[@id='#{base_dom_id}_1i']").select(date.year.to_s)
          find(:xpath, ".//select[@id='#{base_dom_id}_2i']").select(I18n.l date, :format => '%B')
          find(:xpath, ".//select[@id='#{base_dom_id}_3i']").select(date.day.to_s)
        end
      
        # Select a Rails time. Options has must include :from => +label+
        def select_time(time, options)
          time        = Time.zone.parse(time)
          base_dom_id = get_base_dom_id_from_label_tag(options[:from])

          find(:xpath, ".//select[@id='#{base_dom_id}_4i']").select(time.hour.to_s.rjust(2, '0'))
          find(:xpath, ".//select[@id='#{base_dom_id}_5i']").select(time.min.to_s.rjust(2,  '0'))
        end
      
        # Select a Rails datetime. Options has must include :from => +label+
        def select_datetime(datetime, options)
          select_date(datetime, options)
          select_time(datetime, options)
        end

        private

        # @example "event_starts_at_"
        def get_base_dom_id_from_label_tag(field)
          find(:xpath, ".//label[contains(., '#{field}')]")['for'].gsub(/(_[1-5]i)$/, '')
        end
      end
    end
  end
end

World(::Cucumber::Rails::Capybara::SelectDatesAndTimes)
