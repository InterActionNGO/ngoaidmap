require 'rails_helper'

RSpec.describe Sector, type: :model do
  subject { create(:sector) }

  it { should have_and_belong_to_many(:projects) }

end
