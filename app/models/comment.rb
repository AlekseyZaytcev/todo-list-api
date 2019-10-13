# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task

  validates :body, presence: true, length: { in: 10..256 }
end
