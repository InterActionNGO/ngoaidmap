require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { create(:project) }

  it { should belong_to(:primary_organization).with_foreign_key(:primary_organization_id).class_name('Organization') }
  it { should belong_to(:prime_awardee).with_foreign_key(:prime_awardee_id).class_name('Organization') }
  it { should have_and_belong_to_many(:clusters) }
  it { should have_and_belong_to_many(:sectors) }
  it { should have_and_belong_to_many(:regions) }
  it { should have_and_belong_to_many(:tags) }
  it { should have_and_belong_to_many(:geolocations) }
  it { should have_many(:resources).with_foreign_key(:element_id).dependent(:destroy) }
  it { should have_many(:media_resources).with_foreign_key(:element_id).dependent(:destroy) }
  it { should have_many(:donations).dependent(:destroy) }
  it { should have_many(:donors).through(:donations) }
  it { should have_and_belong_to_many(:sites) }

end
