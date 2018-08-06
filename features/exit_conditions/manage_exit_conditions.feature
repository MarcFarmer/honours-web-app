@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to manage exit conditions by editing risk score, deleting exit conditions and having links to edit exit steps
  So I can edit and remove existing exit conditions and exit steps

Scenario: User edits existing edit condition
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Given I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "0" to "3"
  When I press the first edit exit condition button
  Then the first edit exit step section should contain "Unsynchronised DC Shock" with risk "0" to "3"
  When I fill in the first edit exit step section with "Synchronised DC Shock" with risk "1" to "4"
  And I press "Save"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should not see "0 to 3"
  And I should see "1 to 4"

Scenario: User deletes existing exit condition
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Given I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "0" to "3"
  When I press the first remove exit condition button
  Then I should be on the edit first step of first pathway page for the newest pathway
  Then I should not see "0 to 3"

Scenario: User follows link to an exit condition
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Given I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "0" to "3"
  When I follow "Unsynchronised DC Shock"
  Then I should see "Editing Unsynchronised DC Shock"
