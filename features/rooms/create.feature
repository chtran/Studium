@rooms_create
@javascript
Feature: Create room
  As a user
  I want to be able to create a room
  So that I can start learning and invite people to join with me

  Background:
    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password" in "HTA" browser
    And I am signed in as "chautran@studium.vn" with password "password" in "Chau" browser

  Scenario: Room list is updated when new room is created
    Given I wait 1 seconds in "HTA" browser
    And I press "New room"
    And I wait 1 seconds
    And I fill in "Room title" with "HTA's room"
    And I select "Critical Reading" from "Room mode"
    And I press "Create Room"
    And I wait 1 seconds
    Then "Anh Hoang" should be in the user list
    And the status of "Anh Hoang" should be "Answering"
    Given I wait 1 seconds in "Chau" browser
    Then room "HTA's room" should be in the room list
    And the room mode of "HTA's room" should be "Critical Reading"
