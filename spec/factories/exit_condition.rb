FactoryGirl.define do
  factory :exit_condition do |f|
    f.min_risk { 0 }
    f.max_risk { 1 }
    step
    association :exit_step, factory: :step
  end
end