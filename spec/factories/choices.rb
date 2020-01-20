# frozen_string_literal: true

FactoryBot.define do
  factory :choice do
    label { Faker::Games::Zelda.location }
    ref { label.parameterize }
  end
end
