FactoryGirl.define do
  factory :implementer_partnership do
    project
    association :implementer, factory: :organization
  end
end
