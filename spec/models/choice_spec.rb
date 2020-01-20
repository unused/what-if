# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Choice, type: :model do
  let(:choices) { FactoryBot.build :choice, ref: 'first' }
  let(:passages) do
    [
      FactoryBot.build(:passage, ref: 'first'),
      FactoryBot.build(:passage, ref: 'second', choices: Array(choices))
    ]
  end
  let(:story) { FactoryBot.build :story, passages: passages }

  it 'provides the referenced passage' do
    story.save!

    expect(story.passages.last.choices.first.destination).to eq passages.first
  end

  context 'by referencing itself' do
    let(:choices) { FactoryBot.build(:choice, ref: 'second') }

    it 'can reference it\'s own passage' do
      story.save!

      expect(story.passages.last.choices.first.destination).to eq passages.last
    end
  end

  context 'if no start passage given' do
    it 'provides first passage as initial' do
      expect(story.initial.ref).to eq 'first'
    end
  end

  context 'with given start passage' do
    let(:passages) do
      [
        FactoryBot.build(:passage, ref: 'first'),
        FactoryBot.build(:passage, ref: 'Start')
      ]
    end

    it 'provides start passage as initial' do
      story.save!
      expect(story.initial.ref).to eq 'Start'
    end
  end
end
