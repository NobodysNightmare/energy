class BatterySimulation
  def initialize(battery, site, time_range, step_size)
    @battery = battery
    @statistics = SiteStatistics.new(site, time_range.first.to_time, time_range.last.to_time)
    @step_size = step_size
  end

  def simulate
    each_frame do |frame_start, frame_end|
      frame_duration = (frame_end - frame_start).seconds
      export = @statistics.exports.energy_between(frame_start, frame_end)
      import = @statistics.imports.energy_between(frame_start, frame_end)

      discharged = @battery.discharge(import, duration: frame_duration)
      charged, consumed = @battery.charge(export, duration: frame_duration)

      yield time: frame_end,
            exported: export - consumed,
            imported: import - discharged,
            discharged: discharged,
            charged: charged,
            battery: @battery
    end
  end

  private

  def each_frame
    from = @statistics.from
    final_end = @statistics.to
    while from < final_end
      to = [from + @step_size, final_end].min
      yield from, to
      from += @step_size
    end
  end
end
