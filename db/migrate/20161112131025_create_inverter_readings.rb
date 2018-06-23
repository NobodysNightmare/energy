# frozen_string_literal: true

class CreateInverterReadings < ActiveRecord::Migration[5.0]
  def change
    create_table :inverter_readings do |t|
      t.references :inverter, null: false
      t.datetime :time, null: false
      t.integer :value, null: false
    end

    add_index :inverter_readings, %i[inverter_id time], unique: true
    add_index :inverter_readings, :time

    add_foreign_key :inverter_readings, :inverters, on_delete: :cascade
  end
end
