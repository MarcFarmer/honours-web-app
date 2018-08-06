When /I press the first edit exit condition button/ do
  within '#editable_list.exit-conditions' do
    page.find('.button-edit').click
  end
end

When /I press the first edit question or instruction button/ do
  within '#editable_list.questions-instructions' do
    page.find('.button-edit').click
  end
end

Then /the first edit exit step section should contain "(.*)" with risk "(.*)" to "(.*)"/ do |name, min, max|
  expect(page.find('.edit-in-list')).to have_content(name) # check that name of exit step is present

  # check that risk scores are pre-filled
  within('.edit-in-list') do
    edit_fields = page.all('input.score-range-field')
    expect(edit_fields.count).to eq(2), 'Wrong fields.'
    expect(edit_fields.first.value).to eq(min), 'Wrong min risk.'
    expect(edit_fields.last.value).to eq(max), 'Wrong max risk.'
  end
end

When /I fill in the first edit exit step section with "(.*)" with risk "(.*)" to "(.*)"/ do |name, min, max|
  within('.edit-in-list') do
    edit_fields = page.all('input.score-range-field')
    expect(edit_fields.count).to eq(2), 'Wrong fields.'
    edit_fields[0].set(min)
    edit_fields[1].set(max)
  end
end

When /I press the first remove exit condition button/ do
  within '#editable_list.exit-conditions' do
    page.find('a.button-remove').click
  end
end

When /I press the first remove question or instruction button/ do
  first_item = page.first('.editable-item')
  within first_item do
    page.find('.button-remove').click
  end
end

When /I press the first move down button/ do
  within all('.editable-item').first do
    page.find('.button-down').click
  end
end

When /I press the last move up button/ do
  within all('.editable-item').last do
    page.find('.button-up').click
  end
end
