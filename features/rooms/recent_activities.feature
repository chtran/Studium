@recent_activities
Feature: Recent Activities
  As a user
  When I am in rooms#index
  I want to see recent activities updates
  So I feel like a part of the community

  Background:
    Given the following users exist:
      | name | email                | password |
      | HTA  | anhhoang@studium.vn  | password |
      | Chau | chautrang@studium.vn | password |
      | Kien | kienhoang@studium.vn | password |
    And I am logged in as anhhoang@studium.vn in HTA's browser
    Then I am logged in as chautran@studiun.vn in Chau's browser
    And I am logged in as kienhoang@studium.vn in Kien's browser

  @enter_room_no_invited
  Scenario: Enter room (without being invited)
    Given I create a room with title "Hello world" in HTA's browser
    And I wait 5 seconds 
    Then I should see "HTA has joined room Hello world" in Chau's browser
    And I join room Hello world in Chau's browser
    Then I should see "Chau has joined room Hello world" in Kien's browser


