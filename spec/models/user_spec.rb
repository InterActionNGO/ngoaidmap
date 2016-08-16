require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should belong_to(:organization) }

end
