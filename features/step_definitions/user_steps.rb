Given /^the following users exist:$/ do |table|
  table.hashes.each do |user|
    @user=User.create! user
    @user.admin=user[:admin] || false
    @user.save
  end
end

Given /^user "(.+)" has the following profile info:$/ do |email,table|
  table.hashes.each do |profile_info|
    @profile=Profile.create! profile_info.merge!(user_id: User.find_by_email!(email).id)
  end
end

Given /^I am signed in as "(.+)" with password "(.+)"$/ do |email,password|
  visit(new_user_session_path)
  step %Q[I fill in "Email" with "#{email}"]
  step %Q[I fill in "Password" with "#{password}"]
  step %Q[I press "Sign in"]
end
