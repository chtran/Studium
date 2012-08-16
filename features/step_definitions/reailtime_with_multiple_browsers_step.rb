When /^I am in "(.*)" browser$/ do |name|
  Capybara.session_name = name
end

When /^(?!I am in)(.*(?= in)) in "(.*)" browser$/ do |extra_step, name|
  step %Q[I am in "#{name}" browser] 
  step %Q[#{extra_step}]
end


When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end
