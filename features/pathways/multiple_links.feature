@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want the graph of steps in a pathway to show multiple links to one step
  So that I can see which steps have multiple parent steps

Scenario: User creates multiple exit conditions that lead to the same step
  Given I am editing exit steps for a pathway with name "Tachycardia"
  When I submit the new exit condition form with next step "Check if QRS is narrow" and score "0" to "0"
  And I submit the new exit condition form with next step "Synchronised DC Shock" and score "1" to "4"
  Then I follow "Check if QRS is narrow"
  And I press the exit conditions tab
  And I submit the new exit condition form with next step "Release patient" and score "0" to "0"
  Then I follow "Go back to Is patient stable?"
  Then I press the exit conditions tab
  And I follow "Synchronised DC Shock"
  Then I press the exit conditions tab
  And I submit the new exit condition form with next step "Release patient" and score "0" to "0"
  When I follow "View all steps"
  Then I should see "Release patient"
