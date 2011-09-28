module Cucumber
  module Rails
    module Capybara
      # This module defines methods for selecting dates and times
      module SelectDatesAndTimes
        # Select a Rails date with label +field+
        # The +options+ hash should contain a Date parseable date (as a string) 
        def select_date(field, options)
          date        = Date.parse(options[:with])
          base_dom_id = get_base_dom_id_from_label_tag(field)

          find(:xpath, ".//select[@id='#{base_dom_id}_1i']").select(date.year.to_s)
          find(:xpath, ".//select[@id='#{base_dom_id}_2i']").select(I18n.l date, :format => '%B')
          find(:xpath, ".//select[@id='#{base_dom_id}_3i']").select(date.day.to_s)
        end
      
        # Select a Rails time with label +field+
        # The +options+ hash should contain a Time parseable time (as a string) 
        def select_time(field, options)
          time        = Time.zone.parse(options[:with])
          base_dom_id = get_base_dom_id_from_label_tag(field)

          find(:xpath, ".//select[@id='#{base_dom_id}_4i']").select(time.hour.to_s.rjust(2, '0'))
          find(:xpath, ".//select[@id='#{base_dom_id}_5i']").select(time.min.to_s.rjust(2,  '0'))
        end
      
        # Select a Rails date and time with label +field+
        # The +options+ hash should contain a Date/Time parseable time (as a string) 
        def select_datetime(field, options)
          select_date(field, options)
          select_time(field, options)
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
