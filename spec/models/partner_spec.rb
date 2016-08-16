require 'rails_helper'

RSpec.describe Partner, type: :model do
  subject { create(:partner) }

  it { should belong_to(:site) }
end
