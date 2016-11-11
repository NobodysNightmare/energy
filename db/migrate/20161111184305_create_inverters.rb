# frozen_string_literal: true
class CreateInverters < ActiveRecord::Migration[5.0]
  def change
    create_table :inverters do |t|
      t.string :name
      t.string :serial
      t.integer :capacity

      t.timestamps
    end

    add_index :inverters, :serial, unique: true
  end
end
