# frozen_string_literal: true
class Reading < ApplicationRecord
  belongs_to :inverter

  validates :inverter_id, presence: true
  validates :time, presence: true, uniqueness: { scope: :inverter_id }
  validates :value, presence: true
end
