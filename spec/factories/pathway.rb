FactoryGirl.define do
  factory :pathway do |f|
    sequence :name do |n|
      "Pathway Name #{n}"
    end
  end
end