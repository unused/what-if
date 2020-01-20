# frozen_string_literal: true

require 'rails_helper'

require Rails.root.join('lib', 'twee')

RSpec.feature Twee::Interpreter do
  let(:contents) { YAML.safe_load File.read file_fixture 'contents.yml' }
  let(:number) { [*0..100].sample }
  let(:init_state) { { '$num': number } }

  attr_reader :result, :state
  def load_content(key, state = {})
    described_class.new(contents[key], state).tap do |interpreter|
      @result = interpreter.parse
      pp interpreter.ast if ENV.key? 'DEBUG'
      @state = interpreter.state
    end
  end

  def result
    @result.respond_to?(:squish) ? @result.squish : @result
  end

  it 'results to text only' do
    load_content 'text_only'

    expect(result).to eq 'text without any code.'
  end

  it 'results to multiline text only' do
    load_content 'multiline_text'

    expect(result).to start_with 'This still has'
    expect(result).to end_with 'more than one line.'
  end

  it 'updates state' do
    load_content 'state'

    expect(state[:$bar]).to eq 42
    expect(result).to be_empty
  end

  it 'updates state within text' do
    load_content 'text_and_state'

    expect(state[:$bar]).to eq 2
    expect(result).to eq 'text and state.'
  end

  it 'updates state within multiline text' do
    load_content 'multiline_text_and_state'

    expect(state[:$baz]).to eq 7
    expect(result).to eq 'This has some text text.'
  end

  it 'initializes state (and has text)' do
    load_content 'state_init'

    expect(state[:$bar]).to eq 42
    expect(state[:$foo]).to eq 0
    expect(result).to eq 'This still has text.'
  end

  it 'handles an alternative assignment syntax' do
    load_content 'alternative_assignment'

    expect(state[:$foo]).to eq 4
    expect(result).to eq 'This still has text.'
  end

  it 'updates state via addition (and has text)' do
    load_content 'state_update_add', init_state

    expect(state[:$num]).to eq(number + 4)
    expect(result).to eq 'This still has text.'
  end

  it 'updates state via subtraction (and has text)' do
    load_content 'state_update_sub', init_state

    expect(state[:$num]).to eq(number - 2)
    expect(result).to eq 'This still has text.'
  end

  describe 'conditions' do
    it 'handles conditions' do
      load_content 'condition'
      expect(result).to eq 'Bar is not 42'
      load_content 'condition', :$bar => 42
      expect(result).to eq 'Bar is 42'
    end

    it 'handles embedded conditions' do
      load_content 'embedded_condition'
      expect(result).to eq 'One Three'
      load_content 'embedded_condition', :$two => 2
      expect(result).to eq 'One Two Three'
    end

    it 'handles equality compare' do
      load_content 'equals'
      expect(result).to be_empty
      load_content 'equals', :$bar => 7
      expect(result).to eq 'Bar is 7'
    end

    it 'handles greater than' do
      load_content 'greater_than'
      expect(result).to be_empty
      load_content 'greater_than', :$bar => 42
      expect(result).to be_empty
      load_content 'greater_than', :$bar => 43
      expect(result).to eq 'Bar is greater than 42'
    end

    it 'handles greater than equal' do
      load_content 'greater_than_equal'
      expect(result).to be_empty
      load_content 'greater_than_equal', :$bar => 41
      expect(result).to be_empty
      load_content 'greater_than_equal', :$bar => 42
      expect(result).to eq 'Bar is greater than or equal 42'
    end

    it 'handles lower than' do
      load_content 'lower_than'
      expect(result).to be_empty
      load_content 'lower_than', :$bar => 42
      expect(result).to be_empty
      load_content 'lower_than', :$bar => 41
      expect(result).to eq 'Bar is lower than 42'
    end

    it 'handles lower than equal' do
      load_content 'lower_than_equal'
      expect(result).to be_empty
      load_content 'lower_than_equal', :$bar => 43
      expect(result).to be_empty
      load_content 'lower_than_equal', :$bar => 42
      expect(result).to eq 'Bar is lower than or equal 42'
    end
  end

  context 'with or operator' do
    it 'combines conditions' do
      pending
      load_content 'logical_operator_or'
      expect(result).to eq 'no'
      # load_content 'logical_operator_or', { :bar => 2 }
      # expect(result).to eq 'yes'
      # load_content 'logical_operator_or', { :foo => 3 }
      # expect(result).to eq 'yes'
    end
  end

  context 'with and operator' do
    it 'combines conditions' do
      pending
      load_content 'logical_operator_and'
      expect(result).to eq 'no'
      load_content 'logical_operator_and', bar: 2
      expect(result).to eq 'yes'
      load_content 'logical_operator_and', foo: 3
      expect(result).to eq 'yes'
    end
  end
end
