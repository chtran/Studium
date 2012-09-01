@signing_in
Feature: Signing in
	In order to sign in as a user
	As a guest
	I want to be able to sign in and get redirected to the rooms#index

	Background:
		Given the following users exist:
			| email               | password | admin |
			| anhhoang@studium.vn | password | true  |
    And the following users exist:
      | email           | password |
      | info@studium.vn | password |
    And user "anhhoang@studium.vn" has the following profile info:
      | first_name | last_name |
      | Anh        | Hoang     |
    And user "info@studium.vn" has the following profile info:
      | first_name | last_name |
      | Studium    | Team      |
		And I am on the home page

  @signing_in_no_admin
	Scenario: Sign in normally (not an admin)
		When I follow sign_in url
		And I fill in "Email" with "info@studium.vn"
		And I fill in "Password" with "password"
		And I press "Sign in"
		Then I should be on the dashboard
		And I should see "Sign out"

  @signing_in_admin
	Scenario: Sign in normally (as an admin)
		When I follow sign_in url
		And I fill in "Email" with "anhhoang@studium.vn"
		And I fill in "Password" with "password"
		And I press "Sign in"
		Then I should be on the rooms page
		And I should see "Sign out"
    And I should see "Admin Page"
