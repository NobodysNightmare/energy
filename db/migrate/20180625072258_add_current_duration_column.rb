# frozen_string_literal: true

class AddCurrentDurationColumn < ActiveRecord::Migration[5.0]
  def up
    add_column :meters, :current_duration, :integer, default: 300, null: false
  end

  def down
    remove_column :meters, :current_duration
  end
end
