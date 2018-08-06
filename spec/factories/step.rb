FactoryGirl.define do
  factory :step do
    sequence :name do |n|
      "Step Name #{n}"
    end
    pathway # Association with pathway model
  end
end