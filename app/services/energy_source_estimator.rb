# frozen_string_literal: true

class EnergySourceEstimator
  # Estimation also depends on readings of other meters of the same site
  # Avoding race condition between other meters being updated and estimation
  # being created by not creating estimations for very fresh readings
  ESTIMATION_DELAY = 5.minutes

  def initialize(meter)
    @meter = meter
    @start = meter.energy_source_estimates.order(:time).last&.time || meter.readings.order(:time).first.time
    @end = meter.readings.order(:time).last.time
    @site_stats = SiteStatistics.new(meter.site, @start, @end)
    @interval = meter.site.meters.where(active: true, meter_type: %i[grid_import generator]).maximum(:current_duration)
  end

  def append_estimates
    previous_reading = @meter.readings.order(:time).where('time <= ?', @start).last
    previous_estimate = @meter.energy_source_estimates.order(:time).last
    @meter.readings.order(:time).where('time > ? AND time <= ?', @start, ESTIMATION_DELAY.ago).each do |reading|
      if previous_reading
        next if reading.time - previous_reading.time < @interval

        total_energy = reading.value - previous_reading.value
        generated_fraction = generated_fraction(previous_reading, reading)
        imported_fraction = 1 - generated_fraction

        generated = total_energy * generated_fraction + (previous_estimate&.generated || 0)
        imported = total_energy * imported_fraction + (previous_estimate&.imported || 0)

        previous_estimate = @meter.energy_source_estimates.create!(
          time: reading.time,
          generated: generated.floor,
          imported: imported.ceil
        )
      end

      previous_reading = reading
    end
  end

  def reestimate_all
    @meter.energy_source_estimates.delete_all
    append_estimates
  end

  private

  def generated_fraction(previous_reading, reading)
    total_generated = @site_stats.generators.energy_between(previous_reading.time, reading.time)
    total_imported = @site_stats.imports.energy_between(previous_reading.time, reading.time)
    total_exported = @site_stats.exports.energy_between(previous_reading.time, reading.time)

    net_generated = total_generated - total_exported
    total_energy = net_generated + total_imported

    # Either might happen due to low resolution of certain meters
    return 0 if net_generated.negative? || total_energy.zero?

    Rational(net_generated, total_energy)
  end
end
