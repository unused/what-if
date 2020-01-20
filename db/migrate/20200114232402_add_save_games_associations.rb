# frozen_string_literal: true

class AddSaveGamesAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :save_games do |t|
      t.references :user
      t.references :story
      t.references :passage
    end
  end
end
