FactoryGirl.define do
  factory :tag do
    sequence :name do |n|
      "Tag Name #{n}"
    end
    pathway # Association with pathway model
  end
end