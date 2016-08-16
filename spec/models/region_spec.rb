require 'rails_helper'

RSpec.describe Region, type: :model do
  subject { create(:region) }

  it { should belong_to(:country) }
  it { should belong_to(:region).with_foreign_key(:parent_region_id) }
  it { should have_and_belong_to_many(:projects) }

end
