# frozen_string_literal: true

module UnitHelper
  def format_watt(value)
    value, prefix = prefix(value)
    "#{value} #{prefix}W"
  end

  def format_watt_peak(value)
    value, prefix = prefix(value)
    "#{value} #{prefix}Wp"
  end

  def format_watt_hours(value)
    value, prefix = prefix(value)
    "#{value} #{prefix}Wh"
  end

  private

  def prefix(value)
    if value >= 1000
      [(value / 1000.0).round(1), 'k']
    else
      [value.round(1), '']
    end
  end
end
