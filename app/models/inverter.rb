# frozen_string_literal: true
class Inverter < ApplicationRecord
  has_many :inverter_readings

  validates :name, presence: true, uniqueness: true
  validates :serial, presence: true, uniqueness: true
end
