# frozen_string_literal: true

class AddResetColumnsToMeter < ActiveRecord::Migration[7.0]
  def change
    add_column :meters, :reset_from, :integer, null: false, default: 0
    add_column :meters, :reset_to, :integer, null: false, default: 0
  end
end
