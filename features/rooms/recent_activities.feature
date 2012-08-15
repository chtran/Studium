@recent_activities
Feature: Recent Activities
  As a user
  When I am in rooms#index
  I want to see recent activities updates
  So I feel like a part of the community

  Background:
    Given the following users exist:
      | email                | password |
      | anhhoang@studium.vn  | password |
      | chautrang@studium.vn | password |
      | kienhoang@studium.vn | password |
    And I am logged in as anhhoang@studium.vn in HTA's browser
    Then I am logged in as chautran@studiun.vn in Chau's browser
    And I am logged in as kienhoang@studium.vn in Kien's browser
    When I am in rooms index in HTA's browser
    And I am in rooms index in Chau's browser
    And I am in rooms index in Kien's browser

  @enter_room_no_invited
  Scenario: Enter room (without being invited)
    Given I create a room with title "Hello world" in HTA's browser
    And I wait 5 seconds 
    Then I should see "HTA has joined room Hello world" in Chau's browser
    And I click "join" room Hello world in Chau's browser
    And I wait 5 seconds
    Then I should see "Chau has joined room Hello world" in Kien's browser

  @leave_room_no_invited
  Scenario: Leave room (without being invited)
    Given there exists room "Hello world"
    And I am in room "Hello world" in HTA's browser
    And I am in room "Hello world" in Chau's browser
    When I click "quit" room in HTA's browser
    And I wait 5 seconds
    Then I should see "HTA has left room Hello world" in Kien's browser
    

