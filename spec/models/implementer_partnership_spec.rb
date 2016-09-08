require 'rails_helper'

RSpec.describe ImplementerPartnership, type: :model do
  subject { create(:implementer_partnership) }

  it { should belong_to(:project) }
  it { should belong_to(:implementer).class_name('Organization') }
end
