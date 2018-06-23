# frozen_string_literal: true

class RemoveCapacityColumn < ActiveRecord::Migration[5.0]
  def up
    remove_column :meters, :capacity
  end
end
