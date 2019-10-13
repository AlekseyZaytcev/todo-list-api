# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { create(:task) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:project_id) }
end
