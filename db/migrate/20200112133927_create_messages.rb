# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :data_type
      t.string :data

      t.timestamps
    end
  end
end
