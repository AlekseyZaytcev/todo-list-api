# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to have_many(:projects).dependent(:destroy) }
  it { is_expected.to have_many(:tasks).through(:projects) }

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:password) }

  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

  it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(50) }
  it { is_expected.to validate_length_of(:password).is_equal_to(8) }

  it { is_expected.to allow_value('1A2s4P0z').for(:password) }
  it { is_expected.not_to allow_value('1A@s4P$z').for(:password) }
end
