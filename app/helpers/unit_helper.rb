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

  def format_currency(value)
    if value < 1.0
      number_to_currency(value * 100, unit: 'ct', format: '%n %u')
    else
      number_to_currency(value, unit: '€', format: '%n %u')
    end
  end

  private

  def prefix(value)
    if value.abs >= 1000
      [(value / 1000.0).round(1), 'k']
    else
      [value.round(1), '']
    end
  end
end
