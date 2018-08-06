@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to choose an existing or new step as the next step in the pathway
  so I can choose which step the follows the current step

Scenario: User adds new step as next step
  Given I am editing exit steps for a pathway with name "Tachycardia"
  Then I should not see "click link to edit step"
  And I should see "Visit this step when score is"
  When I submit the new exit condition form with next step "Synchronised DC Shock" and score "1" to "4"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should see "Synchronised DC Shock"
  And I should see "1 to 4"
  And I should see "click link to edit step"
  And the new exit condition form fields should be empty

Scenario: User tries to add next step with invalid (negative) min risk score
  Given I am editing exit steps for a pathway with name "Tachycardia"
  When I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "-1" to "4"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should not see "Synchronised DC Shock"
  And I should not see "click link to edit step"

Scenario: User tries to add next step with min risk score larger than max risk score
  Given I am editing exit steps for a pathway with name "Tachycardia"
  When I submit the new exit condition form with next step "Unsynchronised DC Shock" and score "4" to "1"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should not see "Synchronised DC Shock"
  And I should not see "click link to edit step"
  And I should see "The maximum score must be greater than or equal to the minimum score"
