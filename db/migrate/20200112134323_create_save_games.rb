# frozen_string_literal: true

class CreateSaveGames < ActiveRecord::Migration[6.0]
  def change
    create_table :save_games do |t|
      t.string :state_json

      t.timestamps
    end
  end
end
