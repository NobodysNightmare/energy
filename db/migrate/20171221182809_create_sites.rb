# frozen_string_literal: true
class CreateSites < ActiveRecord::Migration[5.0]
  def up
    create_table :sites do |t|
      t.string :name, null: false
      t.timestamps
    end

    change_table :meters do |t|
      t.belongs_to :site, index: true
    end
  end

  def down
    remove_column :meters, :site_id
    drop_table :sites
  end
end
