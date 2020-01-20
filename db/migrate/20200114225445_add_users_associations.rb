# frozen_string_literal: true

class AddUsersAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.references :active_game
    end
  end
end
