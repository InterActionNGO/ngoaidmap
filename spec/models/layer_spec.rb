require 'rails_helper'

RSpec.describe Layer, type: :model do
  subject { create(:layer) }

  it { should have_many(:site_layers) }
  it { should have_many(:sites).through(:site_layers) }
end
