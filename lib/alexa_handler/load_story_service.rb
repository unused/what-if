# frozen_string_literal: true

# Selects a story from given request
class LoadStoryService
  attr_reader :story

  def initialize(request)
    @request = request
    set_story
  end

  def update(user)
    save_game = user.save_games.find_or_create_by story: story
    user.update active_game: save_game
  end

  def found?
    story.present?
  end

  private

  def set_story
    return @story = Story.all.sample if title == 'random story'

    @story = Story.find_by title: title
  end

  def title
    @title ||= @request.slot :story
  end
end
