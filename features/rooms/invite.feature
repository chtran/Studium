@rooms_invite
Feature: Invite people to room
  As a user
  I want to be able to invite users to my room

  Background:

    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password" in "HTA" browser
    And I am signed in as "chautran@studium.vn" with password "password" in "Chau" browser

  Scenario: User accepting invitation
    Given I wait 1 seconds in "Chau" browser
    And I create a room with title "Chau's room" and room mode "Critical Reading"
    Then "Chau Tran" should be in the user list with status "Answering"
    Given I wait 1 seconds in "HTA" browser
    And I wait 4 seconds in "Chau" browser
    And I press "Invite"
    And I wait 1 seconds
    Then I should see "Anh Hoang"
    Given I follow "Anh Hoang"
    And I wait 1 seconds in "HTA" browser
    Then I should see "You're invited!"
    Given I press "Accept"
    And I wait 1 seconds
    Then I should see "Please wait for the next round to begin"
    Given I wait 1 seconds in "Chau" browser
    Then "Anh Hoang" should be in the user list with status "Observing"

