# frozen_string_literal: true

# A story passage.
#
#    field :ref, type: String
#    field :body, type: String
class Passage < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  belongs_to :story
  has_many :choices

  def final?
    choices.empty?
  end

  # Content cleared from scripts and choices.
  def text
    strip_tags strip_links strip_scripts body
  end

  private

  def strip_scripts(text)
    text.gsub(/<<[^>>]+>>/, '')
  end

  def strip_links(text)
    text
      .gsub(/\[{2}/, '')
      .gsub(/\|[^\]]+\]{2}/, '')
      .gsub(/\]{2}/, '')
  end
end
