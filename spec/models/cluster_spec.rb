require 'rails_helper'

RSpec.describe Cluster, type: :model do
  subject { create(:cluster) }

  it { should have_and_belong_to_many(:projects) }
end
