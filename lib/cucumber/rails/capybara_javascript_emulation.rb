module Cucumber
  module Rails
    module CapybaraJavascriptEmulation
      def self.included(base)
        base.class_eval do
          alias_method :click_without_rails_javascript_emulation, :click
        end
      end
  
      def click_with_rails_javascript_emulation
        if tag_name == 'a' and node['onclick'] =~ /m\.setAttribute\('name', '_method'\)/
          method = node['onclick'].match(/m\.setAttribute\('value', '([^']*)'\)/)[1]
 
          js_form = node.document.create_element('form')
          js_form['action'] = self[:href]
          js_form['method'] = 'POST'
 
          input = node.document.create_element('input')
          input['type'] = 'hidden'
          input['name'] = '_method'
          input['value'] = method
          js_form.add_child(input)
 
          Capybara::Driver::RackTest::Form.new(driver, js_form).submit(self)
        else
          click_without_rails_javascript_emulation
        end
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