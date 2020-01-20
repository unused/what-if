# frozen_string_literal: true

class CreateChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :choices do |t|
      t.string :label
      t.string :ref

      t.timestamps
    end
  end
end
