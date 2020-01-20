# frozen_string_literal: true

# Application view helper for generic stuff.
module ApplicationHelper
  def page_title(content)
    content.tap { content_for :title, content }
  end
end
