@rooms_join
@javascript
Feature: Playing in a room
  As a user
  I want to be able to play in a room
  So that I can learn the SAT individually or in a group

  Background:
    Given I have run the seed task
    And the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password" in "HTA" browser
    And I wait 1 seconds

  @rooms_single
  Scenario: Single player
    And I create a room with title "HTA's room" and room mode "Critical Reading"
    Then "Anh Hoang" should be in the user list
    And the status of "Anh Hoang" should be "Answering"
    Given "Anh Hoang" chooses the choice "A"
    And I press "Confirm"
    And I wait 14 seconds
    Then "Anh Hoang" should see the correct explanation
    Given I press "Ready"
    And I wait 5 seconds
    Then the status of "Anh Hoang" should be "Answering"

  @rooms_multi
  Scenario: Multi player
    Given I am signed in as "chautran@studium.vn" with password "password" in "Chau" browser
    And I wait 1 seconds
    And I create a room with title "HTA's room" and room mode "Critical Reading" in "HTA" browser
    Then "Anh Hoang" should be in the user list
    And the status of "Anh Hoang" should be "Answering"
    Given "Anh Hoang" chooses the choice "A"
    And I press "Confirm"
    And I wait 7 seconds
    Then "Anh Hoang" should see the correct explanation
    Given I expand room "HTA's room" in "Chau" browser
    And I follow "Join"
    And I wait 1 seconds
    Then I should see "Please wait for the next round to begin"
    Given I press "Ready" in "HTA" browser
    And I wait 5 seconds
    Then the status of "Anh Hoang" should be "Answering"
    Then "Chau Tran" should be in the user list
    And the status of "Chau Tran" should be "Answering"
    Given "Anh Hoang" chooses the choice "A"
    And I press "Confirm"
    And I wait 7 seconds
    And "Chau Tran" chooses the choice "B" in "Chau" browser
    And I press "Confirm"
    And I wait 7 seconds
    Then "Chau Tran" should see the correct explanation
    And "Anh Hoang" should see the correct explanation in "HTA" browser
    And the status of "Anh Hoang" should be "Confirmed"
    And the status of "Chau Tran" should be "Confirmed"
    Given I press "Ready"
    And I wait 3 seconds
    Then the status of "Anh Hoang" should be "Ready"
    Given I press "Ready" in "Chau" browser
    And I wait 3 seconds
    Then the status of "Chau Tran" should be "Answering"
    Then the status of "Anh Hoang" should be "Answering"
