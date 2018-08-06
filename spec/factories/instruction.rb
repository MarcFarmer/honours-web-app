FactoryGirl.define do
  factory :instruction do |f|
    sequence :content do |n|
      "Instruction Content #{n}"
    end
    step
  end
end
