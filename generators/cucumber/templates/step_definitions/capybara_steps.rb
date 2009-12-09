# IMPORTANT: This file was generated.
# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.
# Consider adding your own code to a new file instead of editing this one.

require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    within(locator || 'html') { yield }
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^\"]*)"(?: within "([^\"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When /^(?:|I )follow "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|I )fill in "([^\"]*)" for "([^\"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following(?: within "([^\"]*)"|)?:$/ do |fields, selector|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      When %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^\"]*)" from "([^\"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
When /^(?:|I )select "([^\"]*)" as the date and time(?: within "([^\"]*)")?$/ do |time, selector|
  with_scope(selector) do
    select_datetime(time)
  end
end

# Use this step when using multiple datetime_select helpers on a page or
# you want to specify which datetime to select. Given the following view:
#   <%%= f.label :preferred %><br />
#   <%%= f.datetime_select :preferred %>
#   <%%= f.label :alternative %><br />
#   <%%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" date and time
# And I select "November 25, 2004 10:30" as the "Alternative" date and time
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time(?: within "([^\"]*)")?$/ do |datetime, datetime_label, selector|
  with_scope(selector) do
    select_datetime(datetime, :from => datetime_label)
  end
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it.
When /^(?:|I )select "([^\"]*)" as the time(?: within "([^\"]*)")?$/ do |time, selector|
  with_scope(selector) do
    select_time(time)
  end
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time(?: within "([^\"]*)")?$/ do |time, time_label, selector|
  with_scope(selector) do
    select_time(time, :from => time_label)
  end
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^(?:|I )select "([^\"]*)" as the date(?: within "([^\"]*)")?$/ do |date, selector|
  with_scope(selector) do
    select_date(date)
  end
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date(?: within "([^\"]*)")?$/ do |date, date_label, selector|
  with_scope(selector) do
    select_date(date, :from => date_label)
  end
end

When /^(?:|I )check "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end

When /^(?:|I )uncheck "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end

When /^(?:|I )choose "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end

When /^(?:|I )attach the file at "([^\"]*)" to "([^\"]*)"(?: within "([^\"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, path)
  end
end

Then /^(?:|I )should see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      has_content?(text).should be_true
    else
      assert has_content?(text)
    end
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      has_xpath?('//*', :text => regexp).should be_true
    else
      assert has_xpath('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      has_content?(text).should be_false
    else
      assert_not has_content?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      has_xpath?('//*', :text => regexp).should be_false
    else
      assert_not has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      field_labeled(field).value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_labeled(field).value)
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should not contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      find_field(field).value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, find_field(field).value)
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      field_labeled(label)['checked'].should == 'checked'
    else
      assert field_labeled(label)['checked'] == 'checked'
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      field_labeled(label)['checked'].should_not == 'checked'
    else
      assert field_labeled(label)['checked'] != 'checked'
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  if defined?(Spec::Rails::Matchers)
    URI.parse(current_url).path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), URI.parse(current_url).path
  end
end

Then /^show me the page$/ do
  save_and_open_page
end