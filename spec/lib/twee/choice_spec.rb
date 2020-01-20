# frozen_string_literal: true

require 'rails_helper'

require Rails.root.join('lib', 'twee')

RSpec.feature Twee::Choice do
  let(:str) { '[[Go Home]]' }
  let(:subject) { Twee::Choice.new str }

  it 'extracts label' do
    expect(subject.label).to eq 'Go Home'
  end

  it 'extracts id' do
    expect(subject.id).to eq 'Go Home'
  end

  context 'for explicit labels' do
    let(:str) { '[[Go Home|Home]]' }

    it 'extracts label' do
      expect(subject.label).to eq 'Go Home'
    end

    it 'extracts id' do
      expect(subject.id).to eq 'Home'
    end
  end
end
