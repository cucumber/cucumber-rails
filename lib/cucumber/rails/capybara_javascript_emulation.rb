module Cucumber
  module Rails
    module CapybaraJavascriptEmulation
      def self.included(base)
        base.class_eval do
          alias_method :click_without_rails_javascript_emulation, :click
        end
      end
  
      def click_with_rails_javascript_emulation
        if link_with_onclick_from_rails?
          Capybara::Driver::RackTest::Form.new(driver, js_form(self[:href], emulated_method)).submit(self)
        else
          click_without_rails_javascript_emulation
        end
      end
      

      private
      def js_form(action, emulated_method, method = 'POST')
        js_form = node.document.create_element('form')
        js_form['action'] = action
        js_form['method'] = method

        if emulated_method and emulated_method.downcase != method.downcase
          input = node.document.create_element('input')
          input['type'] = 'hidden'
          input['name'] = '_method'
          input['value'] = emulated_method
          js_form.add_child(input)
        end
        
        js_form
      end

      def link_with_onclick_from_rails?
        tag_name == 'a' and node['onclick'] =~ /var f = document\.createElement\('form'\); f\.style\.display = 'none';/
      end

      def emulated_method
        node['onclick'][/m\.setAttribute\('value', '([^']*)'\)/, 1]
      end
    end
  end
end

class Capybara::Driver::RackTest::Node
  include Cucumber::Rails::CapybaraJavascriptEmulation
end
 
Before('@emulate_rails_javascript') do
  Capybara::Driver::RackTest::Node.class_eval do
    alias_method :click, :click_with_rails_javascript_emulation
  end
end
 
After('@emulate_rails_javascript') do
  Capybara::Driver::RackTest::Node.class_eval do
    alias_method :click, :click_without_rails_javascript_emulation
  end
end
