# frozen_string_literal: true
class Meter < ApplicationRecord
  has_many :readings

  validates :name, presence: true, uniqueness: true
  validates :serial, presence: true, uniqueness: true
end
