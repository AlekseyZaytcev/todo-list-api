# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { FFaker::Lorem.sentences.join(' ') }

    association :task, factory: :task
  end
end
