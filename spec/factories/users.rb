# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { "test_#{FFaker::Internet.user_name}" }
    password { FFaker::Lorem.characters(8) }
  end
end
