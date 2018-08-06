@javascript
Feature: User can create a pathway with a certain name
  As a HC professional who creates and edits clinical pathways,
  I want to be able to add a clinical pathway with a certain name
  so that the pathway name can be seen on the mobile app.

Scenario: User creates a pathway with the name Tachycardia
  Given I am on the home page
  When I press "Create new clinical pathway"
  Then I should be on the home page
  And I should see "What is the name of your clinical pathway?"
  When I fill in the pathway name field with "Tachycardia"
  And I press "Save pathway name and tags"
  Then I should be on the home page
  And I should see "What is the title of the first step in the clinical pathway?"
  When I fill in the step name field with "Is patient stable?"
  And I press "Save and edit the first step"
  Then I should see "Editing Is patient stable?"

Scenario: User creates a pathway with empty tag
  Given I am on the home page
  When I press "Create new clinical pathway"
  When I fill in the pathway name field with "Tachycardia"
  And I follow "New tag"
  And I press "Save pathway name and tags"
  When I fill in the step name field with "Is patient stable?"
  And I press "Save and edit the first step"
  Then I should see "Editing Is patient stable?"

Scenario: User tries to create a pathway with no name
  Given I am on the home page
  When I press "Create new clinical pathway"
  Then I should see "What is the name of your clinical pathway?"
  When I press "Save pathway name and tags"
  Then I should see "What is the name of your clinical pathway?"
  And I should see "Name can't be blank"

Scenario: User tries to create a pathway with no name for the first step
  Given I am on the home page
  When I press "Create new clinical pathway"
  Then I should see "What is the name of your clinical pathway?"
  When I fill in the pathway name field with "Tachycardia"
  And I press "Save pathway name and tags"
  Then I should see "What is the title of the first step in the clinical pathway?"
  When I press "Save and edit the first step"
  Then I should see "What is the title of the first step in the clinical pathway?"
  And I should see "Step title can't be blank"

Scenario: User returns to home page and sees recently edited pathway
  Given I have created a pathway with name "Tachycardia"
  When I follow "View all pathways"
  Then I should be on the home page
  And I should see "Tachycardia"

