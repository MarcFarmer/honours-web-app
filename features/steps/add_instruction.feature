@javascript
Feature: User is able to add an instruction
  As a HC professional who creates and edits clinical pathways
  I want to be able to add an instruction to a step
  so that the instruction can be interacted with on the mobile app

Scenario: User adds an instruction, "Give patient water"
  Given I have created a pathway with name "Sepsis"
  Then I choose "Instruction"
  When I fill in the new instruction form with "Give patient water"
  And I press "Submit instruction"
  Then I should be on the edit pathway step page for the newest pathway
  And I should see "Give patient water"
