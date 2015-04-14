Feature: Drag word
  In order to move a word left and right
  As an emacs user
  I want to drag it

  Background:
    Given I am in buffer "*drag-stuff*"
    And the buffer is empty
    And I insert "word1 word2 word3"
    And there is no region selected
    And I enable drag-stuff

  Scenario: Drag word left
    When I go to word "word3"
    And I press "<M-left>"
    Then I should see "word1 word3 word2"

  Scenario: Drag word right
    When I go to word "word1"
    And I press "<M-right>"
    Then I should see "word2 word1 word3"

  Scenario: Drag word left out of scope
    When I go to word "word1"
    And I press "<M-left>"
    Then I should see "word1 word2 word3"
    And I should see message "Can not move word further to the left"

  Scenario: Drag word right out of scope
    When I go to word "word3"
    And I press "<M-right>"
    Then I should see "word1 word2 word3"
    And I should see message "Can not move word further to the right"
