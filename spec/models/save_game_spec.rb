# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveGame, type: :model do
  let(:save_game) { FactoryBot.create :save_game }

  it 'is initialized with first passage' do
    expect(save_game.passage).to eql save_game.story.initial
  end
end
