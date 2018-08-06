@javascript
Feature: User is able to add a question with multiple answers
  As a HC professional who creates and edits clinical pathways
  I want to be able to add a question to a step
  so that the question can be interacted with on the mobile app

Scenario: User adds a question, "Temperature > 35?" with two answers, "Ans1" and "Ans2"
  Given I have created a pathway with name "Sepsis"
  Given I have added a new question "Temperature > 35?" with answers "Ans1,Ans2" and scores "10,20"
  Then I should be on the edit pathway step page for the newest pathway
  And I should see "Temperature > 35?"
  And I should see "Ans1"
  And I should see "Ans2"
  And I should see "10"
  And I should see "20"
