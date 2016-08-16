FactoryGirl.define do
  factory :donation do
    amount 100
    date { 1.week.ago.to_date }
  end
end
