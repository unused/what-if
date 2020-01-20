# frozen_string_literal: true

# List choices in a text friendly way.
class ChoicesList
  def initialize(choices)
    @choices = choices
  end

  def with_ordinal_prefix
    @choices.each_with_index.map do |choice, index|
      "#{(index + 1).ordinalize} #{choice}"
    end
  end

  def to_s
    with_ordinal_prefix.to_sentence last_word_connector: ' or '
  end
end
