# frozen_string_literal: true
class RenameInverters < ActiveRecord::Migration[5.0]
  def up
    rename_table :inverters, :meters
    rename_column :readings, :inverter_id, :meter_id
  end

  def down
    rename_table :meters, :inverters
    rename_column :readings, :meter_id, :inverter_id
  end
end
