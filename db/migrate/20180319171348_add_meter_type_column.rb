# frozen_string_literal: true
class AddMeterTypeColumn < ActiveRecord::Migration[5.0]
  def up
    add_column :meters, :meter_type, :integer, default: 0, null: false
  end

  def down
    remove_column :meters, :meter_type
  end
end
