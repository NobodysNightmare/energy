# frozen_string_literal: true

class MakeRawValueNotNull < ActiveRecord::Migration[7.0]
  def up
    Reading.where(raw_value: nil).update_all('raw_value = value')
    change_column_null :readings, :raw_value, false
  end

  def down
    change_column_null :readings, :raw_value, false
  end
end
