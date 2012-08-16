@rooms_invite
Feature: Invite people to room
  As a user
  I want to be able to invite users to my room

  Background:
    Given the following users exist:
      | email                | password |
      | anhhoang@studium.vn  | password |
      | chautran@studium.vn  | password |
      | kienhoang@studium.vn | password |
    And user "anhhoang@studium.vn" has the following profile info:
      | first_name | last_name |
      | Anh        | Hoang     |
    And user "chautran@studium.vn" has the following profile info:
      | first_name | last_name |
      | Chau       | Tran      |
    And user "kienhoang@studium.vn" has the following profile info:
      | first_name | last_name |
      | Kien       | Hoang     |
    When I am in "HTA" browser
    And I am signed in as "anhhoang@studium.vn" with password "password"
    When I am in "Chau" browser
    And I am signed in as "chautran@studiun.vn" with password "password"
  @javascript  
  Scenario: Inviting a user
    Given I am in "Chau" browser
    And I wait 3 seconds
    Given I press "New room"
    And I wait 3 seconds
    And I fill in "Room title" with "Derp's room"
    And I select "Shuffled" from "Room mode"
    And I press "Create Room"
    Then "Chau Tran" should be in the user list
