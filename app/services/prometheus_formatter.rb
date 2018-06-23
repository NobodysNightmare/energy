# frozen_string_literal: true

class PrometheusFormatter
  class << self
    def format(readings)
      io = StringIO.new
      write_header(io)
      write_readings(io, readings)
      io.string
    end

    private

    def write_header(io)
      io.puts '# TYPE energy_amount_watt_hours counter'
    end

    def write_readings(io, readings)
      readings.each do |reading|
        labels = labels_for(reading)
        labels = labels.map { |k, v| "#{k}=\"#{v}\"" }.join(',')
        io.puts "energy_amount_watt_hours{#{labels}} " \
                "#{reading.value} #{reading.time.to_datetime.strftime('%Q')}"
      end
    end

    def labels_for(reading)
      {
        site: reading.meter.site.name,
        meter: reading.meter.name,
        type: reading.meter.meter_type
      }
    end
  end
end
