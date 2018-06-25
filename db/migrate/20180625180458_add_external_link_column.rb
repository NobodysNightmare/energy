# frozen_string_literal: true

class AddExternalLinkColumn < ActiveRecord::Migration[5.0]
  def up
    add_column :sites, :external_link, :string, null: true
  end

  def down
    remove_column :sites, :external_link
  end
end
