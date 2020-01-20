# frozen_string_literal: true

require 'rails_helper'

require Rails.root.join('lib', 'twee')

RSpec.feature Twee::Passage do
  let(:passages) { YAML.safe_load File.read file_fixture 'passages.yml' }
  let(:passage) { passages['simple'] }
  let(:lines) { passage.split "\n" }
  let(:subject) do
    Twee::Passage.new(lines.first).tap do |current|
      current.content = lines.slice 1..-1
    end
  end

  it 'extracts id' do
    expect(subject.id).to eq 'Passage'
  end

  it 'extracts (multiline) body' do
    expect(subject.body).to include 'multiple lines'
  end

  it 'extracts choices' do
    expect(subject.choices.length).to eq 3
  end
end
