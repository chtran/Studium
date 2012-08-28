Feature: Create User Profiles
	In order to create profiles when users sign up
	As the system
	I want to create profiles automatically when users sign up

	Background:
		Given I am on the home page
		And I follow "Sign in"
		And I follow "Sign up"

	Scenario: Create User Profiles with Valid Attributes
		When I fill in "Email" with "user@ticketee.com"
		And I fill in "Password" with "password"
		And I fill in "Password confirmation" with "password"
		And I fill in "First name" with "Kien"
		And I fill in "Last name" with "Hoang"
		And I fill in "School" with "Lafayette College"
		And I press "Sign up"
		Then I should be on the dashboard
		When I follow "userboard"
		Then I should be on the profile page for user "user@ticketee.com"
		And I should see "Kien Hoang"
		And I should see "Lafayette College"

	Scenario: Create User Profiles with Invalid Attributes
		When I fill in "Email" with "user@ticketee.com"
		And I fill in "Password" with "password"
		And I fill in "Password confirmation" with "password"
		And I press "Sign up"
		Then I should see "Profile first name can't be blank"
		And I should see "Profile last name can't be blank"
