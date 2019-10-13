# frozen_string_literal: true

class CommentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :comment
  attributes :body
  belongs_to :task
end
