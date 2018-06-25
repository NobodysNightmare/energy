# frozen_string_literal: true

class Meter < ApplicationRecord
  belongs_to :site

  has_many :readings

  enum meter_type: %i[generator grid_import grid_export]

  validates :name, presence: true, uniqueness: { scope: :site_id }
  validates :serial, presence: true, uniqueness: true

  def current_duration
    seconds = super
    ActiveSupport::Duration.build(seconds)
  end
end
