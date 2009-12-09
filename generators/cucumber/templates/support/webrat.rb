require 'webrat'
require 'webrat/core/matchers'
require 'cucumber/webrat/element_locator' # Deprecated in favor of #tableish - remove this line if you don't use #element_at or #table_at

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false # Set to true if you want error pages to pop up in the browser
end

