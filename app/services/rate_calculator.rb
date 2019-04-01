# frozen_string_literal: true

class RateCalculator
  def initialize(rates, rate_type, energy_statistics)
    @rates = rates.sort_by(&:valid_from)
    @rate_type = rate_type
    @energy_statistics = energy_statistics
  end

  def cost_between(from, to)
    cost = 0
    each_rate(from, to) do |rate, from, to|
      price = watt_hour_price(rate.public_send(@rate_type))
      cost += price * @energy_statistics.energy_between(from, to)
    end

    cost
  end

  private

  def each_rate(from, to)
    enum = @rates.enum_for
    prev_rate, next_rate = skip_to_start(enum, from)
    while prev_rate && prev_rate.valid_from < to do
      cycle_from = [prev_rate.valid_from, from].max
      cycle_to = [next_rate&.valid_from, to].compact.min

      yield prev_rate, cycle_from, cycle_to

      prev_rate = next_rate
      next_rate = next_in(enum)
    end
  end

  def skip_to_start(enum, start_date)
    prev_rate = next_in(enum)
    next_rate = next_in(enum)
    while next_rate && next_rate.valid_from < start_date do
      prev_rate = next_rate
      next_rate = next_in(enum)
    end

    [prev_rate, next_rate]
  end

  def next_in(enum)
    enum.next
  rescue StopIteration
    nil
  end

  def watt_hour_price(kwh_price)
    kwh_price / 1000
  end
end
