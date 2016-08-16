require 'rails_helper'

RSpec.describe Office, type: :model do
  subject { create(:office) }

  it { should belong_to(:donor) }
  it { should have_many(:donations) }
  it { should have_many(:projects).through(:donations) }
end
