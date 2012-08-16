Given /^"(.*?)" should be in the user list$/ do |name|
  user_list = page.find("#user_list")
  assert user_list.has_content?(name)
end

And /^the status of "(.*?)" should be "(.*?)"$/ do |name,status|
  user_id = User.find_by_name(name).id
  page.find("#user-#{user_id}").has_content?(status)
end

Then /^"(.*?)" chooses the choice "([A-Z])"$/ do |name,choice_letter|
  user = User.find_by_name(name)
  choice = user.room.question.choices.where(choice_letter: choice_letter).first
  click_button(choice.id.to_s)
end

Then /^"(.*?)" should see the correct explanation$/ do |name|
end

And /^gp of "(.*?)" should change accordingly$/ do |name|
end

