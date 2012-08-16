@rooms_invite
@javascript
Feature: Invite people to room
  As a user
  I want to be able to invite users to my room

  Background:
    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password" in "HTA" browser
    And I am signed in as "chautran@studium.vn" with password "password" in "Chau" browser
  Scenario: Inviting a user
    Given I wait 1 seconds in "Chau" browser
    And I press "New room"
    And I wait 1 seconds
    And I fill in "Room title" with "Chau's room"
    And I select "Critical Reading" from "Room mode"
    And I press "Create Room"
    And I wait 1 seconds
    Then "Chau Tran" should be in the user list
    Given I wait 1 seconds in "HTA" browser
    And I wait 4 seconds in "Chau" browser
    And I press "Invite"
    And I wait 1 seconds
    Then I should see "Chau Tran"
    Given I follow "Chau Tran"
    And I wait 1 seconds in "HTA" browser
    Then I should see "You're invited!"
    Then I press "Accept"
    And I wait 1 seconds
    Then I should see "Please wait for the next round to begin"

