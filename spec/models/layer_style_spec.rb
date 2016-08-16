require 'rails_helper'

RSpec.describe LayerStyle, type: :model do
  subject { create(:layer_style) }

  it { should have_many(:site_layers) }
  it { should have_many(:sites).through(:site_layers) }
end
