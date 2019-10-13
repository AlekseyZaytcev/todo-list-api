# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, uniqueness: { scope: :project_id, case_sensitive: false }
end
