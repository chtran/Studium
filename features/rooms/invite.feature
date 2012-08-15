@javascript
Feature: Invite people to room
  As a user
  I want to be able to invite users to my room

  Background:
    When I am in "Khai" browser
    And I follow "http://gmail.com"
    And I follow "New room"
    And I fill in "Room title" with "Derp's room"
    And I select "Shuffled" from "Room mode"
    And I press "Create Room"
    And I press "Invite"
    When I am in "Derpina" browser
		And I am signed in as "derpina@studium.vn" with password "password"
