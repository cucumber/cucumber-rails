# frozen_string_literal: true

module Cucumber
  module Rails
    module Capybara
      # This module defines methods for selecting dates and times
      module SelectDatesAndTimes
        # Select a Rails date. Options hash must include from: +label+
        def select_date(date, options)
          date = Date.parse(date)
          if ::Rails::VERSION::MAJOR >= 7
            # Rails 7 generates date fields using input type="date". Capybara support's them
            fill_in options[:from], with: date
          else
            base_dom_id = get_base_dom_id_from_label_tag(options[:from])

            find(:xpath, ".//select[@id='#{base_dom_id}_1i']").select(date.year.to_s)
            find(:xpath, ".//select[@id='#{base_dom_id}_2i']").select(I18n.l(date, format: '%B'))
            find(:xpath, ".//select[@id='#{base_dom_id}_3i']").select(date.day.to_s)
          end
        end

        # Select a Rails time. Options hash must include from: +label+
        def select_time(time, options)
          time = Time.zone.parse(time)
          if ::Rails::VERSION::MAJOR >= 7
            # Rails 7 generates date fields using input type="time". Capybara support's them
            fill_in options[:from], with: time
          else
            base_dom_id = get_base_dom_id_from_label_tag(options[:from])

            find(:xpath, ".//select[@id='#{base_dom_id}_4i']").select(time.hour.to_s.rjust(2, '0'))
            find(:xpath, ".//select[@id='#{base_dom_id}_5i']").select(time.min.to_s.rjust(2,  '0'))
          end
        end

        # Select a Rails datetime. Options hash must include from: +label+
        def select_datetime(datetime, options)
          if ::Rails::VERSION::MAJOR >= 7
            # Rails 7 generates datetime fields using input type="datetime-local". Capybara support's them
            fill_in options[:from], with: DateTime.parse(datetime)
          else
            select_date(datetime, options)
            select_time(datetime, options)
          end
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
