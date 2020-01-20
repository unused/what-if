# frozen_string_literal: true

module Twee
  # Parser provides generic parsing rules for several twee story formats to
  # unify their interpretation. This class relies on the parslet rubygem
  # see its documentation for rule usage details.
  class Parser < Parslet::Parser
    root :passage

    # Helper method to shorten expressions with optional surrounding space.
    def with_space(pattern)
      space? >> pattern >> space?
    end

    # High level nodes, a passage consists of repeatable sequences of
    # (embedded) code and text repeatable.
    rule(:passage) { (text.as(:text) | code.as(:code)).repeat.as(:text) }
    rule(:text) { (str('<<').absent? >> any).repeat(1).as(:str) }
    rule(:code) { str('<<') >> with_space(statement) >> str('>>') }

    # Available code statements: Assignment, Condition
    rule(:statement) { assignment.as(:ass) | conditional }

    # State assignments work with equal signs or `to` keyword.
    rule(:assignment) do
      str('set') >> space >> identifier.as(:id) \
        >> with_space(str('to') | str('=')) >> expression.as(:exp)
    end

    # Expressions are evaluated as left-to-right statements.
    rule(:expression) do
      value.as(:value) >> (with_space(any.as(:op)) >> expression.as(:exp)).maybe
    end

    # Condition handling
    rule(:conditional) do
      str('if') >> with_space(condition).as(:condition) >> str('>>') \
        >> passage.as(:then) >> conditional_fallback.as(:else).maybe \
        >> conditional_end
    end

    rule(:conditional_fallback) do
      str('<<') >> with_space(str('else')) >> str('>>') >> passage
    end

    rule(:conditional_end) do
      str('<<') >> with_space(str('endif'))
    end

    rule(:condition) do
      identifier.as(:id) >> with_space(conditional_operator.as(:cond_op)) \
        >> value.as(:val)
    end

    rule(:conditional_statement) do
      str('(').maybe >> with_space(conditional_statement).as(:condstmt) \
        >> str(')').maybe >> (with_space(logical_operator).as(:logical) \
        >> conditional.as(:cond)).maybe
    end

    rule(:conditional_operator) do
      # %w[= eq gte >= gt > lte <= lt <].reduce do |seq, op|
      #   seq.nil? ? str(op) : (seq >> str(op))
      # end
      str('=') | str('eq') | str('gte') | str('>=') | str('gt') | str('>') \
         | str('lte') | str('<=') | str('lt') | str('<')
    end

    rule(:logical_operator) do
      str('or') | str('OR') | str('||') | str('and') | str('AND') | str('&&')
    end

    # Low level parsing rules for data types, helpers, identifiers.
    rule(:value) do
      identifier.as(:id) | integer.as(:int) | string.as(:string)
    end
    rule(:identifier) { str('$') >> match('[a-zA-Z]').repeat(1) }
    rule(:integer) { match('\d').repeat(1) }
    rule(:string) { str('"') >> any.repeat(1) >> str('"') }

    rule(:space) { match('\s') }
    rule(:space?) { space.maybe }
  end
end
