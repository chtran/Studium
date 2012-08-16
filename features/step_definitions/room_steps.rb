Given /^$(.*) should be in the user list$/ do |name|
  user_list = page.find("#user_list")
  asser user_list.has_content(name)
end

And /^I create a room with title "(.*)" and room mode "(.*)"$/ do |title, mode|
  step %Q[I wait 4 seconds]
  step %Q[I press "New room"]
  step %Q[I wait 3 seconds]
  step %Q[I fill in "Room title" with "#{title}"]
  step %Q[I select "#{mode}" from "Room mode"]
  step %Q[I press "Create Room"]
end
