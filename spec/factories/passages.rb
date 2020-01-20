# frozen_string_literal: true

FactoryBot.define do
  factory :passage do
    ref { Faker::Games::Zelda.location.parameterize }
    body { Faker::TvShows::BojackHorseman.quote }
  end
end
