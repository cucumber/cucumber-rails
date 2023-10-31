# frozen_string_literal: true

module Cucumber
  module Rails
    module Capybara
      module JavascriptEmulation
        def self.included(base)
          base.class_eval do
            alias_method :click_without_javascript_emulation, :click
            alias_method :click, :click_with_javascript_emulation
          end
        end

        def click_with_javascript_emulation(*)
          if link_with_non_get_http_method?
            ::Capybara::RackTest::Form.new(
              driver, js_form(element_node.document, self[:href], emulated_method)
            ).submit(self)
          else
            click_without_javascript_emulation
          end
        end

        private

        def csrf?
          csrf_param_node && csrf_token_node
        end

        def csrf_param_node
          element_node.document.at_xpath("//meta[@name='csrf-param']")
        end

        def csrf_param
          csrf_param_node['content']
        end

        def csrf_token_node
          element_node.document.at_xpath("//meta[@name='csrf-token']")
        end

        def csrf_token
          csrf_token_node['content']
        end

        def js_form(document, action, emulated_method, method = 'POST')
          js_form = document.create_element('form')
          js_form['action'] = action
          js_form['method'] = method

          add_hidden_method_input(document, js_form) unless same?(emulated_method, method)

          # rails will wipe the session if the CSRF token is not sent with non-GET requests
          add_hidden_csrf_input(document, js_form) if csrf? && !get?(emulated_method)

          js_form
        end

        def same?(emulated_method, method)
          emulated_method.casecmp(method).zero?
        end

        def add_hidden_method_input(document, js_form)
          input = document.create_element('input')
          input['type'] = 'hidden'
          input['name'] = '_method'
          input['value'] = emulated_method
          js_form.add_child(input)
        end

        def get?(emulated_method)
          same?(emulated_method, 'get')
        end

        def add_hidden_csrf_input(document, js_form)
          input = document.create_element('input')
          input['type'] = 'hidden'
          input['name'] = csrf_param
          input['value'] = csrf_token
          js_form.add_child(input)
        end

        def link_with_non_get_http_method?
          tag_name == 'a' &&
            element_node['data-method'] &&
            element_node['data-method'] =~ /(?:delete|put|post)/
        end

        def emulated_method
          element_node['data-method']
        end

        def element_node
          native
        end
      end
    end
  end
end

module Capybara
  module RackTest
    class Node
      include ::Cucumber::Rails::Capybara::JavascriptEmulation
    end
  end
end

Before('not @no-js-emulation') do
  # Enable javascript emulation
  Capybara::RackTest::Node.class_eval do
    alias_method :click, :click_with_javascript_emulation
  end
end

Before('@no-js-emulation') do
  # Disable javascript emulation
  Capybara::RackTest::Node.class_eval do
    alias_method :click, :click_without_javascript_emulation
  end
end
