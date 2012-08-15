Given /^I am logged in using Google with:$/ do |table|
  table.hashes.each do |user|
    visit "http://gmail.com"
    step %Q[And I fill in "Username" with "#{user.username}"]
    step %Q[And I fill in "Password" with "#{user.password}"]
    step %Q[And I press "Sign in"]
  end
end
