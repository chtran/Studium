@recent_activities
@javascript
Feature: Recent Activities
  As a user
  When I am in rooms#index
  I want to see recent activities updates
  So I feel like a part of the community

  Background:
    Given I have run the seed task
    Given the default users exist
    And I am signed in as "anhhoang@studium.vn" with password "password" in "HTA" browser
    Then I am signed in as "chautran@studiun.vn" with password "password" in "Chau" browser
    And I am signed in as "kienhoang@studium.vn" with password "password" in "Kien" browser
    When I go to "rooms index" in "HTA" browser
    And I go to "rooms index" in "Chau" browser
    And I go to "rooms index" in "Kien" browser

  @enter_room_no_invited
  Scenario: Enter room (without being invited)
    Given I create a room with title "Hello world" and room mode "Shuffled" in "HTA" browser
    And I wait 5 seconds 
    Then I should see "HTA has joined room Hello world" in "Chau" browser
    And I click "join" room Hello world in "Chau" browser
    And I wait 5 seconds
    Then I should see "Chau has joined room Hello world" in "Kien" browser

  @leave_room_no_invited
  Scenario: Leave room (without being invited)
    Given there exists room "Hello world"
    And I am in room "Hello world" in "HTA" browser
    And I am in room "Hello world" in "Chau" browser
    When I click "quit" room in "HTA" browser
    And I wait 5 seconds
    Then I should see "HTA has left room Hello world" in "Kien" browser
    

