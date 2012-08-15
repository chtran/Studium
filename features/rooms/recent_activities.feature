@recent_activities
Feature: Recent Activities
  As a user
  When I am in rooms#index
  I want to see recent activities updates
  So I feel like part of a community

  Background:
    Given the following users exist:
      | name | email                | password |
      | HTA  | anhhoang@studium.vn  | password |
      | Chau | chautrang@studium.vn | password |
      | Kien | kienhoang@studium.vn | password |
    And I am logged in as anhhoang@studium.vn in HTA's browser
    Then I am logged in as chautran@studiun.vn in Chau's browser
    And I am logged in as kienhoang@studium.vn in Kien's browser



