@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to choose the order of questions and instructions after adding them
  So I can choose the order step actions are performed when the pathway is followed

Scenario: User swaps positions of question and instruction
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new instruction "Support ABCs"
  Given I have added a new question "Reduced conciousness?" with answers "Maybe,I don't think so" and scores "10,20"
  Then I should see list items "Support ABCs,Reduced conciousness?"
  When I press the first move down button
  Then I wait for 1 seconds
  Then I should see list items "Reduced conciousness?,Support ABCs"
  When I press the last move up button
  Then I wait for 1 seconds
  Then I should see list items "Support ABCs,Reduced conciousness?"