FactoryGirl.define do
  factory :project do
    name 'One Project'
    start_date Time.now - 1.week
    end_date Time.now + 1.week
  end
end
