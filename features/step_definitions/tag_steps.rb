Given /I am viewing tags for a pathway with name "(.*)"/ do |name|
  steps %Q{
    Given I have created a pathway with name "Pneumonia"
    When I follow the edit pathway link
  }
end

When /I add tags with names "(.*)"/ do |names|
  # add text fields for new tag names
  name_array = names.split(',')

  (name_array.count).times do
    click_link('New tag')
  end

  all_tag_inputs = page.all('.tag-name.text-field')
  expect(all_tag_inputs).to_not be_empty, 'No text fields for tag names found.'

  # fill in text fields with tag names
  all_tag_inputs.each do |field|
    field.set(name_array.shift)
  end
end

Then /I should see tags with names "(.*)"/ do |names|
  # all tag names that should be found
  name_array = names.split(',')

  # remove name from array if found on page
  name_array.delete_if {|name| page.has_text?(name) }

  # remove name from array if found in text field
  all_tag_inputs = page.all('.tag-name.text-field')
  found_names = []
  all_tag_inputs.each do |input|
    found_names << input.value
  end

  # expect no names left that are not found
  name_array = name_array - found_names
  expect(name_array).to be_empty  
end

Given /I am editing tags for a pathway with name "(.*)" with tags "(.*)"/ do |pathway, names|
  steps %Q{
    Given I am viewing tags for a pathway with name "Pneumonia"
    When I add tags with names "#{names}"
    And I press "Save pathway name and tags"
    When I follow the edit pathway link
  }
end

When /I change the tag name "(.*)" to "(.*)"/ do |old_name, new_name|
  old_name_found = false
  all_tag_inputs = page.all('.tag-name.text-field')

  # find tag input field that contains old tag name
  all_tag_inputs.each do |item|
    if item.value == old_name
      old_name_found = true
      item.set(new_name)
      break
    end
  end

  expect(old_name_found).to eq(true), "No text field for tag name '#{old_name}' found."
end

When /I remove the tag with name "(.*)"/ do |name|
  all_tag_inputs = page.all('.tag-name.text-field')
  name_found = false

  # find tag name field that contains tag name to remove
  all_tag_inputs.each_with_index do |item, index|
    if item.value == name
      name_found = true

      links = page.all('a', text: 'remove')
      links[index].click
      break
    end
  end

  expect(name_found).to eq(true), "No text field for tag name '#{name}' found."
end