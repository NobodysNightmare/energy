# frozen_string_literal: true

# Acts mostly like a reading, but is a value computed from different readings
# of a site.
# For an internal meter it tries to indicate how much of the measured
# energy came from local generators and how much came from grid import.
# (Assuming an internal meter measures a part of the total consumption of a site)
class EnergySourceEstimate < ApplicationRecord
  belongs_to :meter

  validates :meter_id, presence: true
  validates :time, presence: true, uniqueness: { scope: :meter_id }
  validates :generated, presence: true
  validates :imported, presence: true

  def total
    generated + imported
  end

  def generated_fraction
    return 0 if total.zero?

    Rational(generated, total)
  end

  def imported_fraction
    1 - generated_fraction
  end
end
