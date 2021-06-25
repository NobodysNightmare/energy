# frozen_string_literal: true

def shuffle_generation(time)
    doy_factor = 1.0 - ([(7 - time.month).abs, 6].min / 8.0)
    tod_factor = 1.0 - ([(13 - time.hour).abs, 6].min / 6.0)
    jitter = 0.8 + rand(0.4)
    jitter * tod_factor * doy_factor * 400
end

def shuffle_consumption(time)
    jitter = 0.8 + rand(0.4)
    jitter * 40
end

return unless Rails.env.development?

puts '========== Running Seeds =========='

User.create!(user_id: 'admin@example.com', email: 'admin@example.com', active: true) unless User.exists?

site = Site.find_or_create_by!(name: 'Test Site')

generator = site.meters.find_or_initialize_by(name: 'Generator', meter_type: :generator, serial: 'test-generator')
generator_value = 0
generator.save!

export = site.meters.find_or_initialize_by(name: 'Export', meter_type: :grid_export, serial: 'test-export')
export_value = 0
export.save!

import = site.meters.find_or_initialize_by(name: 'Import', meter_type: :grid_import, serial: 'test-import')
import_value = 0
import.save!

time = 3.months.ago
now = Time.now

return if Reading.exists?

puts '========== Seeding readings =========='

last_time = time

while time < now
    if last_time.day != time.day
        puts time.to_date.iso8601
        last_time = time
    end

    generation = shuffle_generation(time)
    consumption = shuffle_consumption(time)
    generator.readings.create!(time: time, value: generator_value += generation)
    export.readings.create!(time: time, value: export_value += [generation - consumption, 0].max)
    import.readings.create!(time: time, value: import_value += [consumption - generation, 0].max)

    time += 5.minutes
end
