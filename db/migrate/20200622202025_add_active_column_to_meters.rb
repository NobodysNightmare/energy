# frozen_string_literal: true

class AddActiveColumnToMeters < ActiveRecord::Migration[5.0]
  def change
    add_column :meters, :active, :boolean, null: false, default: true
  end
end
