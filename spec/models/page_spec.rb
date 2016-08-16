require 'rails_helper'

RSpec.describe Page, type: :model do
  subject { create(:page) }

  it { should belong_to(:site) }

end
