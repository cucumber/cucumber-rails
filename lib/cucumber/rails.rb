require 'rails'
if Rails.version.to_f < 3.0
  require 'cucumber/rails2'
else
  require 'cucumber/rails3'
end

require 'cucumber/rails/world'
require 'cucumber/rails/hooks'
require 'cucumber/rails/capybara'

require 'cucumber/web/tableish'
