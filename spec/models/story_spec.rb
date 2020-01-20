# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:story) { FactoryBot.create :story }

  it 'provides a shorthand to fetch passages' do
    passage = story.passages.sample
    expect(story.find_passage(passage.ref)).to eql passage
  end

  it 'has provides the start passage' do
    passage = story.passages.find_or_create_by ref: 'Start'
    expect(story.initial).to eql passage
  end

  it 'has provides the start passage' do
    expect(story.initial).to be story.passages.first
  end

  context 'validates title' do
    let(:story) { FactoryBot.build :story, title: nil }

    it 'accepts valid' do
      story.title = 'valid title'
      expect(story.valid?).to be_truthy
    end
  end
end
