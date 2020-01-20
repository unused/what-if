# frozen_string_literal: true

module Twee
  # A minimalistic Twine (Twee) Story Interpreter.
  #
  # <<set $var = 123>>
  # <<if ($var eq 123)>> ... <<else>> ... <<endif>>
  # <<if ($var eq 123) or ($var eq 321)>>
  # <<if ($var eq 123) and ($var eq 321)>>
  # <<print $var>>
  #
  # remove any other tag...
  class Interpreter
    attr_reader :state, :ast

    def initialize(body, state)
      @body = body
      @state = state
    end

    def parse
      @ast = Parser.new.parse(@body)
      Evaluator.new.apply @ast, state: @state
    rescue Parslet::ParseFailed => e
      Rails.logger.debug \
        "[#{self.class}] failed with #{e.parse_failure_cause.ascii_tree}"

      raise e
    end
  end
end
