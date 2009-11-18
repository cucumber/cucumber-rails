# encoding: utf-8
# IMPORTANT: This file was generated.
# Edit at your own peril - it's recommended to regenerate this file
# in the future When you upgrade to a newer version of Cucumber.
# Consider adding your own code to a new file instead of editing this one.

require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# Commonly used webrat steps
# http://github.com/brynary/webrat

Given /^(?:|ich )bin auf (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|ich )auf (.+) gehe$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|ich )auf "([^\"]*)" drücke$/ do |button|
  click_button(button)
end

When /^(?:|ich )auf "([^\"]*)" klicke$/ do |link|
  click_link(link)
end

When /^(?:|ich )auf "([^\"]*)" innerhalb "([^\"]*)" klicke$/ do |link, parent|
  click_link_within(parent, link)
end

When /^(?:|ich )"([^\"]*)" mit "([^\"]*)" ausfülle$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|ich )"([^\"]*)" in "([^\"]*)" eingebe$/ do |value, field|
  fill_in(field, :with => value)
end

# Wird benutzt, um ein Formular mittels Tabelle zu füllen. Beispiel:
#
#   Wenn ich folgendes eingebe:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|ich )folgendes eingebe:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{ich "#{name}" mit "#{value}" ausfülle}
  end
end

When /^(?:|ich )"([^\"]*)" in "([^\"]*)" auswähle$/ do |value, field|
  select(value, :from => field)
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
When /^(?:|ich )"([^\"]*)" als Datum und Uhrzeit auswähle$/ do |time|
  select_datetime(time)
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
When /^(?:|ich )"([^\"]*)" als "([^\"]*)" Datum und Uhrzeit auswähle$/ do |datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and Then select it.
When /^(?:|ich )"([^\"]*)" als Uhrzeit auswähle$/ do |time|
  select_time(time)
end

# Use this step When using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^(?:|ich )"([^\"]*)" als "([^\"]*)" Uhrzeit auswähle$/ do |time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^(?:|ich )"([^\"]*)" als Datum auswähle$/ do |date|
  select_date(date)
end

# Use this step When using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^(?:|ich )"([^\"]*)" als "([^\"]*)" Datum auswähle$/ do |date, date_label|
  select_date(date, :from => date_label)
end

When /^(?:|ich )"([^\"]*)" anhake$/ do |field|
  check(field)
end

When /^(?:|ich )"([^\"]*)" abhake$/ do |field|
  uncheck(field)
end

When /^(?:|ich )"([^\"]*)" auswähle$/ do |field|
  choose(field)
end

When /^(?:|ich )die Datei "([^\"]*)" als "([^\"]*)" anhänge$/ do |path, field|
  attach_file(field, path)
end

Then /^(?:|ich sollte |sollte (?:|ich )?)"([^\"]*)" sehen$/ do |text|
<% if framework == :rspec -%>
  response.should contain(text)
<% else -%>
  assert_contain text
<% end -%>
end

Then /^(?:|ich sollte |sollte (?:|ich )?)"([^\"]*)" innerhalb "([^\"]*)" sehen$/ do |text, selector|
  within(selector) do |content|
<% if framework == :rspec -%>
    content.should contain(text)
<% else -%>
    assert content.include?(text)
<% end -%>
  end
end

Then /^(?:|ich sollte |sollte (?:|ich )?)\/([^\/]*)\/ sehen$/ do |regexp|
  regexp = Regexp.new(regexp)
<% if framework == :rspec -%>
  response.should contain(regexp)
<% else -%>
  assert_contain regexp
<% end -%>
end

Then /^(?:|ich sollte |sollte (?:|ich )?)\/([^\/]*)\/ innerhalb "([^\"]*)" sehen$/ do |regexp, selector|
  within(selector) do |content|
    regexp = Regexp.new(regexp)
<% if framework == :rspec -%>
    content.should contain(regexp)
<% else -%>
    assert content =~ regexp
<% end -%>
  end
end

Then /^(?:|ich sollte |sollte (?:|ich )?)nicht "([^\"]*)" sehen$/ do |text|
<% if framework == :rspec -%>
  response.should_not contain(text)
<% else -%>
  assert_not_contain text
<% end -%>
end

Then /^(?:|ich sollte |sollte (?:|ich )?)nicht "([^\"]*)" innerhalb "([^\"]*)" sehen$/ do |text, selector|
  within(selector) do |content|
<% if framework == :rspec -%>
    content.should_not contain(text)
<% else -%>
    assert !content.include?(text)
<% end -%>
  end
end

Then /^(?:|ich sollte |sollte (?:|ich )?)nicht \/([^\/]*)\/ sehen$/ do |regexp|
  regexp = Regexp.new(regexp)
<% if framework == :rspec -%>
  response.should_not contain(regexp)
<% else -%>
  assert_not_contain regexp
<% end -%>
end

Then /^(?:|ich sollte |sollte (?:|ich )?)nicht \/([^\/]*)\/ innerhalb "([^\"]*)" sehen$/ do |regexp, selector|
  within(selector) do |content|
    regexp = Regexp.new(regexp)
<% if framework == :rspec -%>
    content.should_not contain(regexp)
<% else -%>
    assert content !~ regexp
<% end -%>
  end
end

Then /^sollte das "([^\"]*)" Feld "([^\"]*)" enthalten$/ do |field, value|
<% if framework == :rspec -%>
  field_labeled(field).value.should =~ /#{value}/
<% else -%>
  assert_match(/#{value}/, field_labeled(field).value)
<% end -%>
end

Then /^sollte das "([^\"]*)" Feld nicht "([^\"]*)" enthalten$/ do |field, value|
<% if framework == :rspec -%>
  field_labeled(field).value.should_not =~ /#{value}/
<% else -%>
  assert_no_match(/#{value}/, field_labeled(field).value)
<% end -%>
end

Then /^sollte die "([^\"]*)" Checkbox angehakt sein$/ do |label|
<% if framework == :rspec -%>
  field_labeled(label).should be_checked
<% else -%>
  assert field_labeled(label).checked?
<% end -%>
end

Then /^sollte die "([^\"]*)" Checkbox nicht angehakt sein$/ do |label|
<% if framework == :rspec -%>
  field_labeled(label).should_not be_checked
<% else -%>
  assert !field_labeled(label).checked?
<% end -%>
end

Then /^(?:|ich sollte |sollte (?:|ich )?)auf (.+) sein$/ do |page_name|
<% if framework == :rspec -%>
  URI.parse(current_url).path.should == path_to(page_name)
<% else -%>
  assert_equal path_to(page_name), URI.parse(current_url).path
<% end -%>
end

Then /^zeig mir die Seite$/ do
  save_and_open_page
end