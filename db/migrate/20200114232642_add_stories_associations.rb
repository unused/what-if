# frozen_string_literal: true

class AddStoriesAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :stories do |t|
      t.references :user
    end
  end
end
