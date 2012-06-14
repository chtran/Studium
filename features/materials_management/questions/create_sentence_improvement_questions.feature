Feature: Create Sentence Improvement Questions
	In order to create new sentence improvement questions
	As an admin
	I want to be able to create new sentence improvement questions in my material ms page

	Background:
		Given the following users exist:
			| email							 | password | admin |
			| admin@ticketee.com | password | true  |
		And I am signed in as "admin@ticktee.com" with password "password"
		And I am on the home page
		When I follow "Admin Page"
		And I follow "Material Management Page"
		And I follow "Questions"
		Then I should be on the index page for materials/questions
		Given I follow "Add Question"

	################## Sentence Improvement questions #################
	Scenario: Create sentence improvement questions with valid attributes
		When I select "Writing (Multiple Choice)" from "Category"
		And I select "Sentence improvement" from "Question Type"
		And I press "Proceed"
		When I fill in "Question Title" with "Testing SI Question"
		And I fill in "Question Prompt" with "Research has shown that <ul 0>chilren, born with the ability to learn</ul 0> any human language, even several laguages at the same time." 
		And I fill in "A" with "children, born with the ability to learn"
		And I fill in "B" with "chilren, when born with the ability for learning"
		And I fill in "C" with "children, they are born with the ability to learn"
		And I fill in "D" with "children born with the ability to be learning"
		And I fill in "E" with "children are born with the ability to learn"
		And I check "question_choice_e_checkbox"
		And I fill in "Experience" with "100"
		And I press "Add Question"
		Then I should be on the index page for materials/questions
		And I should see "Question has been created."
		And I should see "Testing SI Question"
		And I should see "Research has shown that..."
		
	Scenario: Create Sentence Improvement questions with invalid attributes
		When I select "Writing (Multiple Choice)" from "Category"
		And I select "Sentence improvement" from "Question Type"
		And I press "Proceed"
		When I fill in "Question Title" with ""
		And I fill in "Question Prompt" with "" 
		And I fill in "A" with ""
		And I fill in "B" with ""
		And I fill in "C" with ""
		And I fill in "D" with ""
		And I fill in "E" with ""
		And I fill in "Experience" with ""
		And I press "Add Question"
		Then I should see "Invalid Question Information. Question has not been created."
		And I should see "Prompt can't be blank"
		And I should see "Choice A can't be blank"
		And I should see "Choice B can't be blank"
		And I should see "Choice C can't be blank"
		And I should see "Choice D can't be blank"
		And I should see "Choice E can't be blank"
		And I should see "Experience can't be blank"
		And I should see "You haven't selected the correct choice"