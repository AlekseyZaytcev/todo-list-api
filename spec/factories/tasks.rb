# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name      { FFaker::Lorem.sentence }
    deadline  { rand(1.week).seconds.from_now }
    priority  { rand(1..10) }
    completed { [true, false].sample }

    association :project, factory: :project
  end
end
