# frozen_string_literal: true

# A users choice leading to a new passage.
#
#   field :label, type: String
#   field :ref, type: String
class Choice < ApplicationRecord
  belongs_to :passage

  def to_s
    label
  end

  def destination
    passage.story.find_passage ref
  end
end
