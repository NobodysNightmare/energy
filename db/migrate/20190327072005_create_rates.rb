# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.belongs_to :site, null: false
      t.date :valid_from, null: false

      t.decimal :import_rate, scale: 4, precision: 6, null: false
      t.decimal :export_rate, scale: 4, precision: 6, null: false
      t.decimal :self_consume_rate, scale: 4, precision: 6, null: false

      t.timestamps
    end

    add_foreign_key :rates, :sites, on_delete: :cascade
  end
end
