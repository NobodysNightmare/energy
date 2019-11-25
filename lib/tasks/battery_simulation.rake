namespace :battery_simulation do
  task test: :environment do
    site = Site.last
    start = Date.iso8601('2019-06-01')
    stop = Date.iso8601('2019-10-01')

    puts "Simulation for #{site.name}"
    puts

    battery = BatterySimulation::Battery.new(3_200, 2_000, 2_000)
    simulation = BatterySimulation.new(battery, site, start..stop, 15.minutes)
    current_date = start
    total_charged = total_discharged = total_exported = total_imported = 0
    last_cycle = nil
    simulation.simulate do |time:, exported:, imported:, charged:, discharged:, battery:|
      if time.to_date > current_date
        puts "Summary for #{current_date} (at #{time})"
        puts "  Used energy (Battery / Grid): #{total_discharged.to_i} Wh / #{total_imported.to_i} Wh"
        puts "  Overgeneration (Bat. / Grid): #{total_charged.to_i} Wh / #{total_exported.to_i} Wh"
        puts "  Battery end of day: #{battery.current_charge.to_i} Wh / #{battery.capacity} Wh"
        puts last_cycle.inspect
        puts
        current_date = time.to_date
        total_charged = total_discharged = total_exported = total_imported = 0
      end

      total_charged += charged
      total_discharged += discharged
      total_imported += imported
      total_exported += exported

      # DEBUG
      # TODO: battery not being discharged, though not empty
      last_cycle = [charged, discharged, imported, exported]
    end
  end
end
