@javascript
Feature: User can edit the name of an existing step
As a HC professional who creates and edits clinical pathways
I want the modals for editing the pathway/step name and tags on the step edit page to look like the modals from the home page
So that I am encouraged to edit their details.

Scenario: User edits step name a pathway with the name Tachycardia
  Given I have created a pathway with name "Tachycardia"
  And I should see "Editing Is patient stable?"
  When I follow the edit step link
  Then I should be on the edit pathway step page for the newest pathway
  Then I should see "What is the title of the first step in the clinical pathway?"
  When I fill in the step name field with "Check if patient is stable"
  And I press "Save step"
  Then I should be on the edit pathway step page for the newest pathway
  And I should see "Editing Check if patient is stable"
  And I should not see "What is the title of the first step in the clinical pathway"

Scenario: User tries to set empty name for step
  Given I have created a pathway with name "Tachycardia"
  When I follow the edit step link
  When I fill in the step name field with ""
  And I press "Save step"
  Then I should be on the edit pathway step page for the newest pathway
  And I should not see "Editing Check if patient is stable"
  And I should see "What is the title of the first step in the clinical pathway"