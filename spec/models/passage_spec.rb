# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passage, type: :model do
  let(:passage) { FactoryBot.build :passage }

  it 'validates the presence of a reference' do
    pending
    expect(passage.valid?).to be_truthy
    passage.ref = nil
    expect(passage.valid?).to be_falsy
  end
end
