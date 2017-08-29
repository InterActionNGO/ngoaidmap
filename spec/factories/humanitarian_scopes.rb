FactoryGirl.define do
  factory :humanitarian_scope do
    project
    humanitarian_scope_type
    humanitarian_scope_vocabulary
    vocabulary_uri "MyString"
    code "MyString"
    narrative "MyString"
  end
end
