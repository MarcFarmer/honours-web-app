Given /I am editing exit steps for a pathway with name "(.*)"/ do |name|
  steps %Q{
    Given I have created a pathway with name "#{name}"
    When I click the exit conditions tab
  }
end

When /I submit the new exit condition form with next step "(.*)" and score "(.*)" to "(.*)"/ do |next_step, min_risk, max_risk|
  within('div#exit_steps') do
    page.find("input.exit-condition-exit-step").set(next_step)

    score_fields = page.all("input.risk-score-field")
    score_fields[0].set(min_risk)
    score_fields[1].set(max_risk)
  end

  steps %Q{
    And I press "Submit next step and score range"
  }
end

When /I fill in the next step field with "(.*)"/ do |next_step|
  within('div#exit_steps') do
    next_step_field = page.find("input.exit-condition-exit-step")
    next_step_field.set(next_step)
  end
end

When /I follow the autocomplete link "(.*)"/ do |link_text|
  page.find(:css, "li.ui-menu-item", text: link_text).click
end

And /I click on "(.*)" in the autocomplete list/ do |text|
  page.execute_script("$('.ui-menu-item:contains(\"#{text}\")').find('a').trigger('mouseenter').click()")
end

And /the new exit condition form fields should be empty/ do
  within("#ec_form") do
    page.all('input.text-field').each do |field|
      expect(field.value.length).to eq(0)
    end
  end
end
