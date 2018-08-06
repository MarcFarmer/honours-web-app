Given /I have created a pathway with name "(.*)"/ do |name|
  steps %Q{
    Given I am on the home page
    When I press "Create new clinical pathway"
    When I fill in the pathway name field with "#{name}"
    And I press "Save pathway name and tags"
    When I fill in the step name field with "Is patient stable?"
    And I press "Save and edit the first step"
  }
end

When /^I wait for (\d+) seconds?$/ do |secs|
  sleep secs.to_i
end

Given /I have added a new instruction "(.*)"/ do |content|
  steps %Q{
    Then I choose "Instruction"
    When I fill in the new instruction form with "#{content}"
    And I press "Submit instruction"
  }
end

Then /the first edit instruction section should contain "(.*)"/ do |name|
  instruction_field = nil
  within 'div.edit-in-list' do
    instruction_field = page.find(".instruction-content.text-field")
  end

  # check that instruction content is pre-filled
  expect(instruction_field.value).to eq(name), 'Wrong instruction.'
end

When /I fill in the edit instruction section with "(.*)"/ do |content|
  within('div.edit-in-list') do
    page.find("input.instruction-content").set(content)
  end
end

Given /I have added a new question "(.*)" with answers "(.*)" and scores "(.*)"/ do |content, answers, scores|
  steps %Q{
    When I choose "Custom answers"
  }

  answers = answers.split(',')
  scores_array = scores.split(',')
  answers_to_add = scores_array.size - 2 # two answer fields by default, determine how many need to be added
  answers_to_add.times do
    steps %Q{
      When I follow "Add answer"
    }
  end

  # fill in question form fields
  within('div#qi_form-1') do
    page.find("input.question-content").set(content)

    page.all("input.answer-content").each do |field|
      field.set(answers.shift)
    end

    page.all('.risk-score-field').each do |field|
      field.set(scores_array.shift)
    end
  end

  steps %Q{
    And I press "Submit question and answers"
  }
end

Then /the first edit question section should contain "(.*)" with answers "(.*)"/ do |name, answers|
  content_field = nil
  answer_fields = []

  within 'div.edit-in-list' do
    content_field = page.find("input.question-content")
    answer_fields = page.all("input.answer-content")
  end

  expect(content_field.value).to eq(name), 'Wrong question.'

  expected_answers = answers.split(",")
  found_answers = []
  answer_fields.each do |field|
    found_answers << field.value
  end

  expect(expected_answers.uniq.sort).to eq(found_answers.uniq.sort), "Answers for question '#{name}' not found."
end

When /I fill in the edit question section with "(.*)" with answers "(.*)"/ do |content, answers|
  answers = answers.split(',')

  within('div.edit-in-list') do
    page.find("input.question-content").set(content)

    page.all("input.answer-content").each do |field|
      field.set(answers.shift)
    end
  end
end

When /I click the questions and instructions tab/ do
  page.click_link('', :href => '#questions_and_instructions')
end

When /I click the exit conditions tab/ do
  page.click_link('', :href => '#exit_steps')
end

When /I fill in the new instruction form with "(.*)"/ do |content|
  within('div#qi_form-2') do
    page.find("input.instruction-content").set(content)
  end
end

When /I fill in the new question form with "(.*)"/ do |content|
  within('div#qi_form-1') do
    page.find("input.question-content").set(content)
  end
end

When /I fill in the pathway name field with "(.*)"/ do |name|
  page.find('.pathway-name.text-field').set(name)
end

When /I fill in the step name field with "(.*)"/ do |name|
  page.find('.step-name.text-field').set(name)
end

Then /all answer fields should not be empty/ do
  page.all('.answer-number-field').each do |field|
    expect(field.value.blank?).to eq(false)
  end
end

Then /there should be default Yes\/No answers/ do
  within('div#default_answers_fields') do
    page.find('input.answer-content-yes') do |field|
      expect(field.value == 'Yes')
    end

    page.find('input.answer-content-no') do |field|
      expect(field.value == 'No')
    end
  end
end

When /I follow the edit step link/ do
  within('#edit_step_heading') do
    page.find('#edit_step_link').click
  end
end

When /I follow the edit pathway link/ do
  within('#edit_step_heading') do
    page.find('#edit_pathway_link').click
  end
end

Then /I should see list items "(.*)"/ do |names|
  names_array = names.split(',')

  page.all(".editable-item").each do |editable_item|
    within editable_item do
      expect(page).to have_content(names_array.shift)
    end
  end
end

When /I press the exit conditions tab/ do
  within('#step_tabs') do
    page.all('a')[1].click
  end
end

When /I press the questions and instructions tab/ do
  within('#step_tabs') do
    page.all('a')[0].click
  end
end

When /I select answers "(.*)"/ do |answers|
  answers = answers.split(",")

  page.all('.question-answers').each do |answer_group|
    within(answer_group) do
      find('label.answer-button', :text => answers.shift).click
    end
  end
end

When /I search for "(.*)"/ do |term|
  within('#pathway_search') do
    page.find('input').set(term)
  end
end
