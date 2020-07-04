# frozen_string_literal: true

class NullStatistics
  def readings
    []
  end

  def current_power
    0.0
  end

  def total_energy
    0
  end

  def energy_between(_from, _to)
    0
  end

  def latest_reading
    nil
  end
end
