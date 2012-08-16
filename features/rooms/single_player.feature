@rooms_single_player
@javascript
Feature: Playing as a single player
  As a user
  I want to be able to play in a private room
  So that I can learn the SAT individually

  Background:
    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password"
  Scenario: Create a room
    Given I wait 1 seconds
    And I press "New room"
    And I wait 1 seconds
    And I fill in "Room title" with "HTA's room"
    And I select "Critical Reading" from "Room mode"
    And I press "Create Room"
    And I wait 1 seconds
    Then "Anh Hoang" should be in the user list
    And the status of "Anh Hoang" should be "Answering"
    Given "Anh Hoang" chooses the choice "A"
    And I press "Confirm"
    And I wait 2 seconds
    Then "Anh Hoang" should see the correct explanation
    And gp of "Anh Hoang" should change accordingly
    Given I press "Ready"
    And I wait 2 seconds
    Then the status of "Anh Hoang" should be "Answering"
