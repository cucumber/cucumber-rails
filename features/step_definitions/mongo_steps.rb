Given /^mongodb is running on my machine$/ do
  run_simple('echo "exit" | mongo')
end
