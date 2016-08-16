require 'rails_helper'

RSpec.describe Stat, type: :model do
  subject { create(:stat) }

  it { should belong_to(:site) }

end
