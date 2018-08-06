@javascript
Feature: As a HC professional who creates and edits clinical pathways
  I want to edit and remove questions, answers and instructions
  So I can edit and remove the content that a mobile app user will interact with

Scenario: User edits instruction
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new instruction "Support ABCs"
  When I press the first edit question or instruction button
  Then the first edit instruction section should contain "Support ABCs"
  Then I should see "N/A"
  When I fill in the edit instruction section with "Support ABCs; give oxygen"
  And I press "Save"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should see "Support ABCs; give oxygen"

Scenario: User removes instruction
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new instruction "Support ABCs"
  When I press the first remove question or instruction button
  Then I should be on the edit first step of first pathway page for the newest pathway
  Then I should not see "Support ABCs"

Scenario: User edits question and answers
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conciousness?" with answers "Maybe,I don't think so" and scores "10,20"
  When I press the first edit question or instruction button
  Then the first edit question section should contain "Reduced conciousness?" with answers "Maybe,I don't think so"
  When I fill in the edit question section with "Support ABCs" with answers "Yes,No"
  And I press "Save"
  Then I should be on the edit first step of first pathway page for the newest pathway
  And I should see "Support ABCs"
  And I should see "Yes"
  And I should see "No"

Scenario: User removes question and answers
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conciousness?" with answers "Maybe,I don't think so" and scores "10,20"
  When I press the first remove question or instruction button
  Then I should be on the edit first step of first pathway page for the newest pathway
  Then I should not see "Reduced conciousness?"
  And I should not see "Maybe"
  And I should not see "I don't think so"

Scenario: User adds questions and instruction, then removes a question
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conciousness?" with answers "Yes,No" and scores "10,20"
  Given I have added a new question "Chest pain?" with answers "Yes,No" and scores "30,40"
  Given I have added a new instruction "Support ABCs"
  When I press the first remove question or instruction button
  Then I should be on the edit first step of first pathway page for the newest pathway
  Then I should not see "Reduced conciousness?"
  And I should see "Chest pain?"
  And I should see "Support ABCs"

Scenario: User adds answer to question, it has default risk score
  Given I have created a pathway with name "Tachycardia"
  Given I have added a new question "Reduced conciousness?" with answers "Yes,No" and scores "10,20"
  Then I choose "Instruction"
  When I press the first edit question or instruction button
  And I follow "Add answer"
  Then all answer fields should not be empty
