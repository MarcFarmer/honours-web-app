FactoryGirl.define do
  factory :question do |f|
    sequence :content do |n|
      "Question content #{n}"
    end
    step
  end
end
