
# "(.*?)" should be in the user list
# the status of "(.*?)" should be "(.*?)"
# "(.*?)" chooses the choice "([A-Z])"
# "(.*?)" chooses the choice "([A-Z])"
# "(.*?)" should see the correct explanation
# room "(.*?)" should be in the room list
# the room mode of "(.*?)" should be "(.*?)"
# I create a room with title "(.*?)" and room mode "(.*?)"
# I expand room "(.*?)"
# "(.*?)" should be in the user list with status "(.*?)"
#
#


Given /^"(.*?)" should be in the user list$/ do |name|
  user_list = page.find("#user_list")
  assert user_list.has_content?(name)
end

And /^the status of "(.*?)" should be "(.*?)"$/ do |name,status|
  user_id = User.find_by_name(name).id
  assert page.find("#user-#{user_id}").has_content?(status)
end

Then /^"(.*?)" chooses the choice "([A-Z])"$/ do |name,choice_letter|
  user = User.find_by_name(name)
  choice = user.room.question.choices.where(choice_letter: choice_letter).first
  click_button("choice-#{choice.id.to_s}")
end

Then /^"(.*?)" should see the correct explanation$/ do |name|
  user = User.find_by_name(name)
  question = user.room.question
  if user.histories.last.question_id!=question.id
    assert page.has_content?("You didn't select an answer. See explanation below.")
  elsif user.histories.last.choice.correct
    assert page.has_content?("Congratulations! You got the right answer.")
  else
    assert page.has_content?("Sorry you got the wrong answer. See explanation below.")
  end
end

Then /^room "(.*?)" should be in the room list$/ do |title|
  assert page.find("#room_list").has_content?(title)
end

And /^the room mode of "(.*?)" should be "(.*?)"$/ do |title,room_mode|
  room = Room.find_by_title(title)
  assert page.find("#room_#{room.id}").has_content?(room_mode)
end

Given /^I create a room with title "(.*?)" and room mode "(.*?)"$/ do |title,room_mode|
  step %Q[I wait 1 seconds]
  step %Q[I press "New room"]
  step %Q[I wait 1 seconds]
  step %Q[I fill in "Room title" with "#{title}"]
  step %Q[I select "#{room_mode}" from "Room mode"]
  step %Q[I press "Create Room"]
  step %Q[I wait 1 seconds]
end

Given /^I expand room "(.*?)"$/ do |title|
  room = Room.find_by_title(title)
  step %Q[I click on "#room_#{room.id}"]
end

And /^"(.*?)" should be in the user list with status "(.*?)"$/ do |name,status|
  step %Q["#{name}" should be in the user list]
  step %Q[the status of "#{name}" should be "#{status}"]
end

And /^what$/ do
  puts page.body
end
