Feature: creating category types
  As an admin
  I want to be able to create a category type

  Background: creating a new category
    Given the following users exist:
			| email							 | password | admin |
			| admin@ticketee.com | password | true  |
		And I am signed in as "admin@ticketee.com" with password "password"
		And I have run the seed task
		And I am on the home page
		When I follow "Admin Page"
		And I follow "Materials"
		And I follow "Questions"
		Given I follow "Add Question"
    Given the following users exist:
			| email							 | password | admin |
			| admin@ticketee.com | password | true  |
		And I am signed in as "admin@ticketee.com" with password "password"
		And I have run the seed task
		And I am on the home page
    When I follow "Admin Page"
    Then I follow "Materials"
    Then show me the page
    And I follow "Paragraphs"
    And I press "Add Categories"
    And I fill in "Category Name" with "dit"
    And I press "Create CategoryTypes"
    Then I should see "Category has been created."
    Then I should see "dit"


