FactoryGirl.define do
  factory :answer do |f|
    sequence :content do |n|
      "Answer content #{n}"
    end
    question
  end
end
