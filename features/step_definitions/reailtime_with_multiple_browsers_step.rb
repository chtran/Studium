When /^I am in (.*) browser$/ do |name|
  Capybara.session_name = name
end

When /^(?!I am in)(.*(?= in)) in (.*) browser$/ do |job, name|
  step "I am in #{name} browser"
  step "#{job}"
end


When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end
