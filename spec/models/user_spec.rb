# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:story) { FactoryBot.create :story }

  it 'can handle an active game' do
    expect(user.active_game?).to be_falsy
    user.story = story
    expect(user.active_game?).to be_truthy
  end
end
