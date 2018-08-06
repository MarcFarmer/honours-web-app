@javascript
Feature: User can create question with default answers
  As a HC professional in the ED
  I want to be able to toggle between default Yes/No or custom answers for new questions
  So I can create Yes/No questions more quickly

Scenario: User creates a question with default Yes/No answers
  Given I have created a pathway with name "Sepsis"
  When I fill in the new question form with "Temperature > 35?"
  Then there should be default Yes/No answers
  When I press "Submit question and answers"
  Then I should be on the edit pathway step page for the newest pathway
  And I should see "Temperature > 35?"
  And I should see "Yes"
  And I should see "No"
