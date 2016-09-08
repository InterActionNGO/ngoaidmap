require 'rails_helper'

RSpec.describe Partnership, type: :model do
  subject { create(:partnership) }

  it { should belong_to(:project) }
  it { should belong_to(:partner).class_name('Organization') }

end
