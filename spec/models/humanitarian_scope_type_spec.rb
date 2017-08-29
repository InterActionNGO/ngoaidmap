require 'rails_helper'

RSpec.describe HumanitarianScopeType, type: :model do
  subject { create(:humanitarian_scope_type) }

  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).case_insensitive }
  it { should validate_presence_of(:name) }

  describe ".import" do
    it "creates entries for each item in the schema" do
      expect {
        HumanitarianScopeType.import("doc/schemas/humanitarian_scope_type.json")
      }.to change {
        HumanitarianScopeType.count
      }.by(2)
    end
  end
end
