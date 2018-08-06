@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to add, edit and delete multiple tags for a clinical pathway without page reloads
  so I can quickly manage tags for a pathway

Scenario: User adds 4 tags
  Given I am viewing tags for a pathway with name "Pneumonia"
  When I add tags with names "SomeAlternateName,PNA,PNEU,PNE"
  And I press "Save pathway name and tags"
  When I go to the edit pathway step page for the newest pathway
  When I follow the edit pathway link
  Then I should see tags with names "SomeAlternateName,PNA,PNEU,PNE"

Scenario: User edits existing tags
  Given I am editing tags for a pathway with name "Pneumonia" with tags "TheFirstTag,12345"
  When I go to the edit pathway step page for the newest pathway
  And I follow the edit pathway link
  And I wait for 1 seconds
  Then I change the tag name "TheFirstTag" to "Pneumocystis pneumonia"
  And I press "Save pathway name and tags"
  When I go to the edit pathway step page for the newest pathway
  When I follow the edit pathway link

Scenario: User deletes existing tags
  Given I am editing tags for a pathway with name "Pneumonia" with tags "SomeAlternateName,PNA,PNEU,PNE"
  When I go to the edit pathway step page for the newest pathway
  When I follow the edit pathway link
  Then I wait for 1 seconds
  When I remove the tag with name "SomeAlternateName"
  And I press "Save pathway name and tags"
  When I go to the edit pathway step page for the newest pathway
  When I follow the edit pathway link
  Then I should see tags with names "PNA,PNEU,PNE"
  And I should not see "SomeAlternateName"
