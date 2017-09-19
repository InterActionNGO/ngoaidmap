require 'rails_helper'

RSpec.describe HumanitarianScopeType, type: :model do
  subject { create(:humanitarian_scope_type) }

  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).case_insensitive }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }

  describe ".import" do
    it "creates entries for each item in the schema" do
      expect {
        described_class.import("doc/schemas/humanitarian_scope_type.json")
      }.to change {
        described_class.count
      }.by(2)
    end
  end
end
