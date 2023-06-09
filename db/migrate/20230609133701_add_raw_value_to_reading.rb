# frozen_string_literal: true

class AddRawValueToReading < ActiveRecord::Migration[7.0]
  def change
    add_column :readings, :raw_value, :integer, null: true
  end
end
