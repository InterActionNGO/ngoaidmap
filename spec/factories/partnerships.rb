FactoryGirl.define do
  factory :partnership do
    association :partner, factory: :organization
    project
  end
end
