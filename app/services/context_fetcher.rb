# frozen_string_literal: true

class ContextFetcher
  INITIAL_DURATION = 1.hour
  DURATION_GROWTH_FACTOR = 3
  MAX_CONTEXT_DURATION = 3.months

  def initialize(readings)
    @readings = readings
  end

  # fetches ordered readings from the given timeframe,
  # but also tries to include one additional reading
  # before and after the timeframe.
  # Stops trying when none is found within
  # MAX_CONTEXT_DURATION seconds.
  def fetch(from, to)
    result = @readings.order(:time)
                      .where('time >= ? && time <= ?', from, to)
                      .to_a
    add_context_before(result, from)
    add_context_after(result, to)
    result
  end

  private

  def add_context_before(readings, base_time)
    with_exponential_duration do |duration|
      frame = (base_time - duration)..base_time
      result = @readings.order(time: :desc).where(time: frame).first
      if result
        readings.unshift(result)
        break
      end
    end
  end

  def add_context_after(readings, base_time)
    with_exponential_duration do |duration|
      frame = base_time..(base_time + duration)
      result = @readings.order(:time).where(time: frame).first
      if result
        readings.push(result)
        break
      end
    end
  end

  def with_exponential_duration
    duration = INITIAL_DURATION
    while duration < MAX_CONTEXT_DURATION
      yield duration
      duration *= DURATION_GROWTH_FACTOR
    end

    yield MAX_CONTEXT_DURATION
  end
end
