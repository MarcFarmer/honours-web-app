@javascript
Feature: User has buttons below the main page content to switch between QI/exit condition pages and navigate to other pages
  As a HC professional who creates and edits clinical pathways
  I want buttons to switch between editing step/exit conditions and return to the parent step
  So I can choose what to edit from the edit step/exit conditions page

Scenario: User uses buttons to switch between QI/exit condition pages
  Given I have created a pathway with name "Sepsis"
  Then I should see "Submit question and answers"
  When I press the exit conditions tab
  Then I should not see "Submit question and answers"
  And I should see "Submit next step and score range"
  When I press the questions and instructions tab
  Then I should see "Submit question and answers"
  And I should not see "Submit next step and score range"

Scenario: User navigates to parent step
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Given I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "0" to "3"
  Then I should see "Is patient stable?"
  And I should not see "Go back to"
  When I follow "Unsynchronised DC Shock"
  Then I follow "Go back to Is patient stable?"
  Then I should see "Is patient stable?"
  And I should not see "Unsynchronised DC Shock"
