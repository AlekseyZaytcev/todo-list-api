# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { FFaker::Job.title }

    association :user, factory: :user
  end
end
