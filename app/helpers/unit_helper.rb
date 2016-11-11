# frozen_string_literal: true
module UnitHelper
  def format_watt(value)
    value = (value / 1000.0).round(1)
    "#{value} kW"
  end

  def format_watt_peak(value)
    value = (value / 1000.0).round(1)
    "#{value} kWp"
  end

  def format_watt_hours(value)
    value = (value / 1000.0).round(1)
    "#{value} kWh"
  end
end
