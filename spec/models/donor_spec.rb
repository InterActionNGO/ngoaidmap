require 'rails_helper'

RSpec.describe Donor, type: :model do
  subject { create(:donor) }

  it { should have_many(:donations) }
  it { should have_many(:donated_projects).through(:donations).source(:project) }
  it { should have_many(:projects).through(:donations) }
  it { should have_many(:offices) }

end
