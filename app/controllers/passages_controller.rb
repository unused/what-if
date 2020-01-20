# frozen_string_literal: true

# Passages controller provides passages.
class PassagesController < ApplicationController
  before_action :set_story
  before_action :set_passage

  def show
    render status: :ok, json: join_associated(@passage)
  end

  private

  def set_story
    @story = Story.find params[:story_id]
  end

  def set_passage
    @passage = @story.passages.find params[:id]
  end

  def join_associated(passage)
    passage.as_json.merge text: passage.text, story: @story,
                          choices: passage.choices.map(&:as_json)
  end
end
