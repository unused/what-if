# frozen_string_literal: true

require 'fuzzy_match'

# Query matcher for choice select
class QueryMatcher
  def initialize(options)
    @options = options
  end

  def match(option)
    FuzzyMatch.new(@options, must_match_at_least_one_word: true).find option
  end
end
