FactoryGirl.define do
  factory :humanitarian_scope do
    project
    humanitarian_scope_type
    humanitarian_scope_vocabulary
    code "1234567890"
    narrative "MyString"
  end
end
