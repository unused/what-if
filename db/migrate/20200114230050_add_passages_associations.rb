# frozen_string_literal: true

class AddPassagesAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :passages do |t|
      t.references :story
    end
  end
end
