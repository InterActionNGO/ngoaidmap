require 'rails_helper'

RSpec.describe HumanitarianScope, type: :model do
  it { should belong_to(:project) }
  it { should belong_to(:humanitarian_scope_type) }
  it { should belong_to(:humanitarian_scope_vocabulary) }

  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:humanitarian_scope_type) }
  it { should validate_presence_of(:humanitarian_scope_vocabulary) }

  describe "deleting relationships" do
    let!(:scope) { create(:humanitarian_scope) }

    it "cascades when deleting project" do
      expect {
        scope.project.destroy
      }.to change {
        described_class.count
      }.by(-1)
    end

    it "restricts when deleting type" do
      expect {
        scope.humanitarian_scope_type.destroy
      }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "restricts when deleting vocabulary" do
      expect {
        scope.humanitarian_scope_vocabulary.destroy
      }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
