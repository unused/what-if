# frozen_string_literal: true

# Save games controller provides user save games and current active game id.
class SaveGamesController < ApplicationController
  before_action :set_save_game, except: :index

  def index
    render status: :ok, json: save_games
  end

  def show
    render status: :ok, json: join_associated(@save_game)
  end

  def update
    ref = params.require(:save_game)[:passage_ref]
    @save_game.update passage_id: @save_game.story.passages.find_by(ref: ref).id
    render status: :ok, json: join_associated(@save_game)
  end

  def active
    render status: :ok, json: @save_game
  end

  def load
    user.update! active_game_id: @save_game.id
  end

  private

  def save_games
    user.save_games.includes(:story).map do |save_game|
      save_game.as_json.merge story: save_game.story.as_json
    end
  end

  def save_game_params
    params.require(:save_game).permit :story_id, :passage_id
  end

  def set_save_game
    id = params[:id] || params[:save_game_id] || user.active_game_id
    return unless id

    @save_game = user.save_games.find id
  end

  def join_associated(save_game)
    save_game.as_json.merge story: save_game.story.as_json
  end
end
