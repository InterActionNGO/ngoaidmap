FactoryGirl.define do
  factory :stat do
    site
    visits 3
    date { 3.days.ago }
  end
end
