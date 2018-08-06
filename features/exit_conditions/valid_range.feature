@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to be notified of and adhere to the valid score range when choosing the next step
  So I only add next steps with a valid score range

Scenario: User tries to add overlapping score range
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Given I submit the new exit condition form with next step "Synchronised DC Shock" and score "1" to "4"
  When I submit the new exit condition form with next step "Check if QRS is narrow" and score "4" to "5"
  Then I should not see "4 to 5"
  And I should see "cannot overlap"

Scenario: User sees valid score range for questions in the current step
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conscious level?" with answers "A0,A1,A2" and scores "0,1,2"
  Given I have added a new question "Chest pain?" with answers "A0,A2,A4" and scores "0,2,4"
  When I press the exit conditions tab
  Then I should see "0 to 6"

Scenario: User sees updated valid score range after removing a question
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conscious level?" with answers "A0,A1,A2" and scores "0,1,2"
  Given I have added a new question "Chest pain?" with answers "A0,A2,A4" and scores "0,2,4"
  When I press the exit conditions tab
  Then I should see "0 to 6"
  When I press the questions and instructions tab
  Then I press the first remove question or instruction button
  When I press the exit conditions tab
  Then I should see "0 to 4"
