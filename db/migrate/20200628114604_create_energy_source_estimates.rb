# frozen_string_literal: true

class CreateEnergySourceEstimates < ActiveRecord::Migration[5.0]
  def change
    create_table :energy_source_estimates do |t|
      t.references "meter", null: false, foreign_key: { on_delete: :cascade }
      t.datetime "time", null: false
      t.integer "generated", null: false
      t.integer "imported", null: false
      t.index ["meter_id", "time"], unique: true
    end
  end
end
