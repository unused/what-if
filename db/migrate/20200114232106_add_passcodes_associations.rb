# frozen_string_literal: true

class AddPasscodesAssociations < ActiveRecord::Migration[6.0]
  def change
    change_table :passcodes do |t|
      t.references :user, unique: true
    end
  end
end
