# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :styles
      t.string :script
      t.string :settings
      t.string :raw

      t.timestamps
    end
  end
end
