@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to be able to choose between adding a question or an instruction to a step
  so that I can customise the contents within a step on the mobile app.

Scenario: User toggles between question and intruction form
  Given I have created a pathway with name "Sepsis"
  When I choose "Instruction"
  Then I should not see "Answers"
  And I should see "Submit instruction"
  And I should be on the edit pathway step page for the newest pathway
  When I choose "Question"
  Then I should not see "Submit instruction"
  And I should see "Answers"
  And I should see "Submit question and answers"
  And I should be on the edit pathway step page for the newest pathway
