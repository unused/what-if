# frozen_string_literal: true

# A twine story preprocessed.
#
#    field :title, type: String
#    field :styles, type: String
#    field :script, type: String
#    field :settings, type: String
#
#    field :raw, type: String
class Story < ApplicationRecord
  has_many :passages, dependent: :destroy
  has_many :save_games, dependent: :destroy
  belongs_to :user, optional: true

  # TODO: index({ title: 'text' }, unique: true)

  # TODO: check if references can be stored downcased.
  def initial
    find_passage('Start') || passages.first
  end

  def find_passage(ref)
    passages.find_by ref: ref
  end
end
