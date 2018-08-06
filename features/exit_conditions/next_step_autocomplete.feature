@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to search for step titles and see results with autocompletion
  So I know when I am adding an existing step as the next step in the pathway

Scenario: User creates exit condition with an existing step, "Is patient stable?"
  Given I am editing exit steps for a pathway with name "Tachycardia"
  When I fill in the next step field with "patient"
  And I click on "Is patient stable?" in the autocomplete list
  And I fill in the next step field with "Is patient stable?"
  Then I should see "There is already a step with this title"
  And I should see "This next step will be a duplicate of Is patient stable?"

Scenario: User creates exit condition with step that doesn't exist yet
  Given I am editing exit steps for a pathway with name "Tachycardia"
  When I fill in the next step field with "Check if QRS is narrow"
  Then I should see "No matches for Check if QRS is narrow"
  And I should see "A new step will be created"
