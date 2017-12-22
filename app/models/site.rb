# frozen_string_literal: true
class Site < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
