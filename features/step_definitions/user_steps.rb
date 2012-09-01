Given /^the following users exist:$/ do |table|
  table.hashes.each do |user|
    @user=User.create! user
    @user.admin=user[:admin] || false
    @user.save

    # Populate profile info
    @profile=Profile.create! first_name: "Kien",last_name: "Hoang",school: "Lafayette",user_id: @user.id
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

When /^I follow sign_in url$/ do
  visit(new_user_session_path)
end

Given /^the default users exist$/ do
  ah = User.create! email: "anhhoang@studium.vn", password: "password", admin: true
  ct = User.create! email: "chautran@studium.vn", password: "password", admin: true
  kh = User.create! email: "kienhoang@studium.vn", password: "password", admin: true
  Profile.create! user_id: ah.id, first_name: "Anh", last_name: "Hoang"
  Profile.create! user_id: ct.id, first_name: "Chau", last_name: "Tran"
  Profile.create! user_id: kh.id, first_name: "Kien", last_name: "Hoang"
end
