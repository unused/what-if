# frozen_string_literal: true

require 'rails_helper'

RSpec.feature QueryMatcher do
  let(:samples) { YAML.safe_load File.read file_fixture 'choice_matches.yml' }
  let(:choice) { samples[sample][0] }
  let(:match) { samples[sample][1] }
  let(:choices) { samples[sample][1..-1] }
  let(:subject) { described_class.new choices.shuffle }

  let(:sample) { 'match' }

  it 'matches selection and option' do
    expect(subject.match(choice)).to eq match
  end

  context 'for similar choice' do
    let(:sample) { 'similar' }

    it 'matches selection and option' do
      expect(subject.match(choice)).to eq match
    end
  end

  context 'for a close word choice' do
    let(:sample) { 'close_word' }

    it 'matches selection and option' do
      expect(subject.match(choice)).to eq match
    end
  end

  context 'for a strange but similar option' do
    let(:sample) { 'strange_but_similar' }

    it 'matches selection and option' do
      expect(subject.match(choice)).to eq match
    end
  end

  context 'for a close enough option' do
    let(:sample) { 'close_enough' }

    it 'matches selection and option' do
      expect(subject.match(choice)).to eq match
    end
  end

  context 'with a lol option' do
    let(:sample) { 'lol' }

    it 'matches selection and option' do
      expect(subject.match(choice)).to eq match
    end
  end

  context 'for a no matching choice' do
    let(:sample) { 'no_match' }

    it 'it responds with no option' do
      expect(subject.match(choice)).to be_nil
    end
  end
end
