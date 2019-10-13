# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { create(:comment) }

  it { is_expected.to belong_to(:task) }

  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(10).is_at_most(256) }
end
