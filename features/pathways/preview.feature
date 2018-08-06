@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to preview how my pathway will look in the mobile app by answering the questions in steps
  So I can see if the pathway works as I intended before using it on the mobile app

Scenario: User answers questions to follow a clinical pathway
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Chest pain?" with answers "Yes,No" and scores "1,0"
  Given I have added a new question "Systolic BP < 90 mmHg" with answers "Yes,No" and scores "1,0"
  Given I have added a new instruction "Support ABCs; give oxygen"
  When I press the exit conditions tab
  Given I submit the new exit condition form with next step "Synchronised DC Shock" and score "1" to "2"
  Given I submit the new exit condition form with next step "Check if QRS is narrow" and score "0" to "0"
  When I follow "Preview and finish Tachycardia"
  Then I should see "Preview of Is patient stable"
  Then I should see "Support ABCs; give oxygen"
  And I should see "Chest pain?"
  And I should see "Systolic BP < 90 mmHg"
  And I should see "The score for your answers is 0"
  When I select answers "Yes,No"
  Then I should see "The score for your answers is 1"
  And I press "Next step"
  Then I should see "Preview of Synchronised DC Shock"

Scenario: User previews step with no questions or instructions
  Given I have created a pathway with name "Tachycardia"
  When I follow "Preview and finish Tachycardia"
  And I should see "This step does not have any questions or instructions"

Scenario: User previews step with unreachable next step
  Given I have created a pathway with name "Sepsis"
  Given I have added a new instruction "Support ABCs"
  When I press the exit conditions tab
  When I submit the new exit condition form with next step "Release patient" and score "1" to "1"
  When I follow "Preview and finish Sepsis"
  Then I should see "Release patient"
  And I should see "step cannot be reached"
