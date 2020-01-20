# frozen_string_literal: true

# A user uniquely identified by its amazon skill kit identifier.
#
#   # Amazon Skill Kit Identifier
#   field :ask_id, type: String
#
#   # Active game state. On change of the story, we create a save game out of
#   # this state.
#   field :active_game_id, type: BSON::ObjectId
class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :save_games, dependent: :destroy
  has_many :stories, dependent: :destroy
  belongs_to :active_game, class_name: 'SaveGame', optional: true

  validates :ask_id, presence: true

  delegate :story, to: :active_game
  delegate :passage, to: :active_game

  def story=(story)
    self.active_game = save_games.find_or_create_by! story: story
  end

  def passage=(passage)
    active_game.passage_id = passage.id
    active_game.save!
  end

  def active_game?
    !active_game_id.nil?
  end

  def active_game
    return unless active_game?

    @active_game ||= save_games.find active_game_id
  end

  def active_game=(save_game)
    @active_game = nil
    self.active_game_id = save_game.id
  end
end
