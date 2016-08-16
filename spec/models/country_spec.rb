require 'rails_helper'

RSpec.describe Country, type: :model do
  subject { create(:country) }

  it { should have_many(:regions) }
end
