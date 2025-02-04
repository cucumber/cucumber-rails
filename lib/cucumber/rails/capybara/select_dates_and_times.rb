# frozen_string_literal: true

module Cucumber
  module Rails
    module Capybara
      # This module defines methods for selecting dates and times
      module SelectDatesAndTimes
        # Select a Rails date. Options hash must include from: +label+
        def select_date(date, options)
          date = Date.parse(date)
          base_dom_id = get_base_dom_from_options(options)

          # Rails 7 use HTML5 input type="date" by default. If input is not present fallback to plain select boxes alternative.
          # It's safe to use has_css? without waiting/retry. We already know field's label is visible
          if html5_input_field_present?(base_dom_id)
            fill_in options[:from], with: date
          else
            find(:xpath, ".//select[@id='#{base_dom_id}_1i']").select(date.year.to_s)
            find(:xpath, ".//select[@id='#{base_dom_id}_2i']").select(I18n.l(date, format: '%B'))
            find(:xpath, ".//select[@id='#{base_dom_id}_3i']").select(date.day.to_s)
          end
        end

        # Select a Rails time. Options hash must include from: +label+
        def select_time(time, options)
          time = Time.zone.parse(time)
          base_dom_id = get_base_dom_from_options(options)

          # Rails 7 use HTML5 input type="time" by default. If input is not present fallback to plain select boxes alternative.
          # It's safe to use has_css? without waiting/retry. We already know field's label is visible
          if html5_input_field_present?(base_dom_id)
            fill_in options[:from], with: time
          else
            find(:xpath, ".//select[@id='#{base_dom_id}_4i']").select(time.hour.to_s.rjust(2, '0'))
            find(:xpath, ".//select[@id='#{base_dom_id}_5i']").select(time.min.to_s.rjust(2,  '0'))
          end
        end

        # Select a Rails datetime. Options hash must include from: +label+
        def select_datetime(datetime, options)
          base_dom_id = get_base_dom_id_from_label_tag(options[:from])

          # Rails 7 use HTML5 input type="datetime-local" by default. If input is not present fallback to plain select boxes alternative.
          # It's safe to use has_css? without waiting/retry. We already know field's label is visible
          if html5_input_field_present?(base_dom_id)
            fill_in options[:from], with: DateTime.parse(datetime)
          else
            extended_options = options.merge(base_dom_id:)
            select_date(datetime, extended_options)
            select_time(datetime, extended_options)
          end
        end

        private

        def html5_input_field_present?(base_dom_id)
          ::Rails::VERSION::MAJOR >= 7 && page.has_css?("##{base_dom_id}", wait: 0)
        end

        def get_base_dom_from_options(options)
          options[:base_dom_id] || get_base_dom_id_from_label_tag(options[:from])
        end

        # @example "event_starts_at_"
        def get_base_dom_id_from_label_tag(field)
          find(:xpath, ".//label[contains(., '#{field}')]")['for'].gsub(/(_[1-5]i)$/, '')
        end
      end
    end
  end
end

World(Cucumber::Rails::Capybara::SelectDatesAndTimes)
