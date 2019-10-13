# frozen_string_literal: true

class ProjectSerializer
  include FastJsonapi::ObjectSerializer

  set_type :project
  attributes :name
  belongs_to :user
end
