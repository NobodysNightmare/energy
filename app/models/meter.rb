# frozen_string_literal: true

class Meter < ApplicationRecord
  belongs_to :site

  has_many :readings
  has_many :energy_source_estimates, dependent: :delete_all

  enum meter_type: %i[generator grid_import grid_export internal]

  validates :name, presence: true, uniqueness: { scope: :site_id, case_sensitive: false }
  validates :serial, presence: true, uniqueness: { case_sensitive: false }

  def current_duration
    seconds = super
    ActiveSupport::Duration.build(seconds)
  end
end
