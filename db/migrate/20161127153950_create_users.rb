# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_id, null: false, index: { unique: true }, limit: 100
      t.string :email, null: false, default: ''
      t.string :name, null: false, default: ''
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
