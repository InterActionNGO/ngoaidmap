require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { create(:tag) }

  it { should have_and_belong_to_many(:projects) }

end
