# frozen_string_literal: true

class TaskSerializer
  include FastJsonapi::ObjectSerializer

  set_type :task
  attributes :name, :deadline, :completed, :priority
  belongs_to :project
end
