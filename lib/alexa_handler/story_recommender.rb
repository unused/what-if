# frozen_string_literal: true

# Story Recommender recommands stories.
class StoryRecommender
  def samples
    # public_send %i[newest trending random unknown].sample
    newest
  end

  def newest
    qry = Story.order(created_at: :desc).limit(3).pluck :title
    "Some recently added stories are #{qry.join(', ')}"
  end

  def self.tell
    new.samples
  end
end
