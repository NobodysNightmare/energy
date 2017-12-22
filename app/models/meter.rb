# frozen_string_literal: true
class Meter < ApplicationRecord
  belongs_to :site

  has_many :readings

  validates :name, presence: true, uniqueness: { scope: :site_id }
  validates :serial, presence: true, uniqueness: true
end
