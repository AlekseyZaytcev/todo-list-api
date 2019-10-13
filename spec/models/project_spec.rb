# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { create(:project) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
end
