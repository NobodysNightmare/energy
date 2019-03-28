# frozen_string_literal: true

class Site < ApplicationRecord
  has_many :meters
  has_many :rates

  validates :name, presence: true, uniqueness: true
end
