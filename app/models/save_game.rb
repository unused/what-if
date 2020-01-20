# frozen_string_literal: true

# A savegame belonging to a user and story, and memorizing the current state
# and passage.
#
#   field :state_json, type: String
class SaveGame < ApplicationRecord
  belongs_to :user
  belongs_to :story
  belongs_to :passage

  attr_readonly :user_id, :story_id

  # TODO: index({ user: 1, story: 1 }, unique: true)

  before_validation { self.passage ||= story.initial }

  def reset!
    update! passage: story.initial
  end
end
