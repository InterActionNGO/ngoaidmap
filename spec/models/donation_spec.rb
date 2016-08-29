require 'rails_helper'

RSpec.describe Donation, type: :model do
  subject { create(:donation) }

  it { should belong_to(:project) }
  it { should belong_to(:donor).class_name('Organization') }
  it { should belong_to(:office) }

end
