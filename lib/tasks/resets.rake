# frozen_string_literal: true

namespace :resets do
  desc 'Finds and lists value resets that can be found for the given meter'
  task :list, [:meter_id] => :environment do |_, args|
    meter = Meter.find(args[:meter_id])
    puts "Listing resets for meter '#{meter.name}':"
    MeterResetDetector.new(meter).each_reset do |current, previous|
      fixed = current.value == previous.value
      puts "#{current.time}: #{previous.raw_value} -> #{current.raw_value} #{'(fixed)' if fixed}"
    end
  end

  desc 'Finds and fixes value resets for the given meter'
  task :fix, [:meter_id] => :environment do |_, args|
    meter = Meter.find(args[:meter_id])
    puts "Fixing resets for meter '#{meter.name}'..."
    MeterResetDetector.new(meter).fix_resets

    puts 'Done'
  end
end
