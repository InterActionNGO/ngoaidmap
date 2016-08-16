require 'rails_helper'

RSpec.describe Site, type: :model do
  subject { create(:site) }

  it { should belong_to(:theme) }
  it { should belong_to(:geographic_context_country).class_name('Country') }
  it { should belong_to(:geographic_context_region).class_name('Region') }
  it { should have_many(:partners).dependent(:destroy) }
  it { should have_many(:pages).dependent(:destroy) }
  it { should have_and_belong_to_many(:projects) }
  it { should have_many(:stats).dependent(:destroy) }
  it { should have_many(:site_layers) }
  it { should have_many(:layers).through(:site_layers) }

end
