# frozen_string_literal: true

class Rate < ApplicationRecord
  belongs_to :site

  validates :valid_from, presence: true
  validates :import_rate, presence: true
  validates :export_rate, presence: true
  validates :self_consume_rate, presence: true
end
