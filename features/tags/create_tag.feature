@javascript
Feature: User can create a tag for an existing pathway
  As a HC professional who creates and edits clinical pathways,
  I want to be able to add a tag to a clinical pathway
  so that I can search for the pathway using the tag(s) or main name.

Scenario: User creates a tag for an existing pathway and stays on the edit tags page
  Given I have created a pathway with name "Sepsis"
  When I follow the edit pathway link
  When I add tags with names "Septicaemia"
  And I press "Save pathway name and tags"
  When I follow the edit pathway link
  Then I should see tags with names "Septicaemia"

Scenario: User adds new tag with no name for an existing pathway and submits form
  Given I have created a pathway with name "Sepsis"
  When I follow the edit pathway link
  When I follow "New tag"
  And I press "Save pathway name and tags"
  Then I should see "Editing"
