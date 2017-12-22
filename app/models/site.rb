# frozen_string_literal: true
class Site < ApplicationRecord
  has_many :meters

  validates :name, presence: true, uniqueness: true
end
