# frozen_string_literal: true

module Twee
  # Evaluator provides a parslet abstract syntax tree transformation recipe. If
  # you print the tree think of the rules replacing or transforming the nodes
  # from depth (children, leaves) up to the root.
  #
  # The result of the transformation should always be text of the current
  # passage. The current state is provided via the context using apply.
  class Evaluator < Parslet::Transform
    COMPARE = {
      eq: :'==',
      '=': :'==',
      '>': :'>',
      'gt': :'>',
      '>=': :'>=',
      'gte': :'>=',
      '<': :'<',
      'lt': :'<',
      '<=': :'<=',
      'lte': :'<='
    }.freeze

    class UnknownOperatorError < StandardError; end # :nodoc:

    # helper methods
    CompareOp = Struct.new(:left, :right, :operator) do
      def eval
        op = COMPARE[operator.to_sym]

        unless op
          msg = "Compare operator #{operator} is unknown"
          raise UnknownOperatorError, msg
        end
        return false if left.nil?

        left.public_send op, right
      end
    end

    # High level rules
    rule(code: simple(:code)) { code }
    rule(text: simple(:text)) { text }
    rule(text: sequence(:texts)) { texts.join }

    # Assignment, a specific statement
    rule(ass: { id: simple(:id), exp: simple(:exp) }) do
      state[id.to_sym] = exp
      ''
    end

    # Choose context by conditional result.
    rule(condition: simple(:cond), then: simple(:context)) do
      cond ? context : ''
    end
    rule(condition: simple(:cond), then: simple(:context),
         else: simple(:fallback)) { cond ? context : fallback }
    # Evaluate conditional statement.
    rule(id: simple(:id), cond_op: simple(:op), val: simple(:val)) do
      CompareOp.new(state[id.to_sym], val, op).eval
    end

    # rule(cond: { condstmt: simple(:stmt), logical: simple(:logical),
    #              cond: simple(:cond), cnt: simple(:cnt), else: simple(:alt) }) do
    #   logical = logical.to_s.strip
    #   if logical.nil?
    #     cond ? cnt : alt
    #   end

    #   if logical.in? %w[or OR ||]
    #     stmt || cond ? cnt : alt
    #   elsif logical.in? %w[and AND &&]
    #     stmt && cond ? cnt : alt
    #   else
    #     raise 'Unsure how to handle condition'
    #   end
    # end

    # Expressions evaluatin operations, incl. Addition
    rule(value: simple(:val), op: simple(:op), exp: simple(:exp)) do
      case op
      when '+' then val + exp
      when '-' then val - exp
      when '*' then val * exp
      when '/' then val / exp
      else raise UnknownOperatorError, "Operator #{op} is not known"
      end
    end

    # Low level transformation like datatypes (integer, strings, spaces).
    rule(value: simple(:val)) { val }
    rule(id: simple(:id)) { state[id.to_sym] }
    rule(str: simple(:str)) { String(str) }
    rule(int: simple(:val)) { Integer(val) }
    rule(space: simple(:_)) { ' ' }
  end
end
