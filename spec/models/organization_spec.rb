require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { create(:organization) }

  it { should have_many(:resources).with_foreign_key(:element_id).dependent(:destroy) }
  it { should have_many(:media_resources).with_foreign_key(:element_id).dependent(:destroy) }
  it { should have_many(:projects).with_foreign_key(:primary_organization_id) }
  it { should have_many(:awarded_projects).with_foreign_key(:prime_awardee_id).class_name('Project') }
  it { should have_many(:sites).with_foreign_key(:project_context_organization_id) }
  it { should have_many(:donations).through(:projects) }
  it { should have_one(:user) }

end
