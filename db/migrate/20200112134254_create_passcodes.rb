# frozen_string_literal: true

class CreatePasscodes < ActiveRecord::Migration[6.0]
  def change
    create_table :passcodes do |t|
      t.string :code

      t.timestamps
    end
  end
end
