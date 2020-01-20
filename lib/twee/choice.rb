# frozen_string_literal: true

module Twee
  # Choice helper
  class Choice
    attr_reader :id, :label

    def initialize(str)
      @label, @id = str.delete('[]').split '|'
      @id ||= @label
    end

    def to_s
      @label
    end
  end
end
