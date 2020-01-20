# frozen_string_literal: true

require 'rails_helper'

RSpec.feature Twee::Evaluator do
  it 'evaluates a condition' do
    cond = { condition: { id: '$bar', op: '=', val: '42' } }
    result = subject.apply cond
  end
end
