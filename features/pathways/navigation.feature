@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want a navigation page that shows a tree-like graph with links to all steps in the pathway
  So I can see an overview of the pathway and navigate to any step

Scenario: User uses navigation page with graph of steps in the pathway
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conciousness?" with answers "Yes,No" and scores "10,20"
  Given I have added a new question "Chest pain?" with answers "Yes,No" and scores "30,40"
  When I press the exit conditions tab
  Given I submit the new exit condition form with next step "Synchronised DC Shock" and score "1" to "4"
  Given I submit the new exit condition form with next step "Check if QRS is narrow" and score "0" to "0"
  Then I follow "Synchronised DC Shock"
  Given I have added a new instruction "3 shock attempts"
  When I follow "View all steps"
  Then I should see "Click on a step"
  And I should see "Viewing all steps in pathway Tachycardia"
  And I should see "Is patient stable?"
  And I should see "Reduced conciousness?"
  And I should see "Chest pain?"
  And I should see "Synchronised DC Shock"
  And I should see "3 shock attempts"
  And I should see "Check if QRS is narrow"
