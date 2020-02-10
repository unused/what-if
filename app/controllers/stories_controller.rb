# frozen_string_literal: true

# Stories controller lists all available (public) stories.
class StoriesController < ApplicationController
  def index
    @stories = user.stories.where.not(title: nil).order(title: :asc)
  end

  def create
    raise FileSizeLimitError if params[:file].size >= 5.megabyte

    @story = user.stories.create! raw: params[:file].read
    ConvertWorker.perform_async String(@story.id)
  end
end
