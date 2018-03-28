# frozen_string_literal: true

# Given a sorted (by time) array of readings,
# allows to find the two readings that surround a given
# time.
class NeighbourFinder
  def initialize(readings)
    @readings = readings
  end

  def readings_around(time)
    left = 0
    right = @readings.size - 1
    while right - left > 1
      probed_index = (left + right) / 2
      probed_time = @readings[probed_index].time
      left = probed_index if time >= probed_time
      right = probed_index if time <= probed_time
    end

    [@readings[left], @readings[right]]
  end
end
