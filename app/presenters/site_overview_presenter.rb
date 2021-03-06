# frozen_string_literal: true

class SiteOverviewPresenter < SimpleDelegator
  def current_power_draw
    (imports.current_power + generators.current_power) - exports.current_power
  end

  def current_generator_power
    generators.current_power
  end

  def current_grid_export_power
    exports.current_power
  end

  def current_grid_import_power
    imports.current_power
  end

  def daily_energy_generation
    generators.total_energy
  end

  def daily_energy_draw
    (imports.total_energy + generators.total_energy) - exports.total_energy
  end

  def daily_energy_import
    imports.total_energy
  end

  def daily_energy_export
    exports.total_energy
  end

  def latest_reading
    [generators, exports, imports].map(&:latest_reading).compact.max_by(&:time)
  end

  private

  def generators
    @generators ||= CollectiveReadingStatistics.new(
      meters.generator.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: Time.current.beginning_of_day,
          to: Time.current,
          current_duration: meter.current_duration
        )
      end
    )
  end

  def exports
    @exports ||= CollectiveReadingStatistics.new(
      meters.grid_export.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: Time.current.beginning_of_day,
          to: Time.current,
          current_duration: meter.current_duration
        )
      end
    )
  end

  def imports
    @imports ||= CollectiveReadingStatistics.new(
      meters.grid_import.map do |meter|
        ReadingStatistics.new(
          meter.readings,
          from: Time.current.beginning_of_day,
          to: Time.current,
          current_duration: meter.current_duration
        )
      end
    )
  end
end
