@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to search for clinical pathways by name and tags
  So I can find existing clinical pathways to view and edit them

Scenario: User searches by pathway name and tag
  Given I have created a pathway with name "Sepsis"
  Given I have created a pathway with name "Tachycardia"
  When I follow the edit pathway link
  Then I add tags with names "PEPSI"
  And I press "Save pathway name and tags"
  And I follow "View all pathways"
  When I search for "Psi"
  Then I should see "Sepsis"
  And I should see "Tachycardia"
