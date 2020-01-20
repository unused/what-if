# frozen_string_literal: true

class AddChoicesAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :choices do |t|
      t.references :passage
    end
  end
end
