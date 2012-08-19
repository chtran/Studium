@rooms_join
@javascript
Feature: Playing in a room
  As a user
  I want to be able to play in a room
  So that I can learn the SAT individually or in a group

  Background:
    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password"
  Scenario: Create a room
    Given I wait 1 seconds
    And I create a room with title "HTA's room" and room mode "Critical Reading"
    Then "Anh Hoang" should be in the user list
    And the status of "Anh Hoang" should be "Answering"
    Given "Anh Hoang" chooses the choice "A"
    And I press "Confirm"
    And I wait 10 seconds
    Then "Anh Hoang" should see the correct explanation
    Given I press "Ready"
    And I wait 5 seconds
    Then the status of "Anh Hoang" should be "Answering"
