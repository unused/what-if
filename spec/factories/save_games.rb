# frozen_string_literal: true

FactoryBot.define do
  factory :save_game do
    user
    story

    before(:create) do |save_game|
      save_game.passage = save_game.story.initial
    end
    after(:create) do |save_game|
      save_game.user.update active_game: save_game
    end
  end
end
