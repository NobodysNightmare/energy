# frozen_string_literal: true
class Inverter < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :serial, presence: true, uniqueness: true
end
