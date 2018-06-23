# frozen_string_literal: true

class Reading < ApplicationRecord
  belongs_to :meter

  validates :meter_id, presence: true
  validates :time, presence: true, uniqueness: { scope: :meter_id }
  validates :value, presence: true
end
