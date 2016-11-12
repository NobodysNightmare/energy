# frozen_string_literal: true
class CreateInverters < ActiveRecord::Migration[5.0]
  def change
    create_table :inverters do |t|
      t.string :name, null: false
      t.string :serial, null: false
      t.integer :capacity, null: false

      t.timestamps
    end

    add_index :inverters, :serial, unique: true
  end
end
