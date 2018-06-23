# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.string :name, null: false
      t.string :secret, null: false

      t.timestamps
    end

    add_index :api_keys, :name, unique: true
    add_index :api_keys, :secret, unique: true
  end
end
