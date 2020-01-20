# frozen_string_literal: true

class CreatePassages < ActiveRecord::Migration[6.0]
  def change
    create_table :passages do |t|
      t.string :ref
      t.string :body

      t.timestamps
    end
  end
end
