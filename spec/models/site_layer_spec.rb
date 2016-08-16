require 'rails_helper'

RSpec.describe SiteLayer, type: :model do
  subject { create(:site_layer) }

  it { should belong_to(:site) }
  it { should belong_to(:layer) }
  it { should belong_to(:layer_style) }

end
