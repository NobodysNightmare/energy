# frozen_string_literal: true
class RenameInverterReadings < ActiveRecord::Migration[5.0]
  def change
    rename_table :inverter_readings, :readings
  end
end
