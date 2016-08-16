require 'rails_helper'

RSpec.describe Theme, type: :model do
  subject { create(:theme) }

  it { should have_many(:sites) }

end
