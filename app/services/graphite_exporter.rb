# frozen_string_literal: true

class GraphiteExporter
  class << self
    attr_accessor :default
  end

  def initialize(hostname, port = 2003)
    @hostname = hostname
    @port = port
  end

  def export(readings)
    TCPSocket.open(@hostname, @port) do |sock|
      Array(readings).each do |reading|
        site = normalize reading.meter.site.name
        meter = normalize reading.meter.name
        meter_type = reading.meter.meter_type
        value = reading.value
        time = reading.time.to_i
        sock.puts "energy.sites.#{site}.meters.#{meter_type}.#{meter} #{value} #{time}"
      end
    end
  end

  private

  def normalize(name)
    ActiveSupport::Inflector.transliterate(name).gsub(/[[:punct:]]/, '').gsub(/[[:space:]]+/, '-')
  end
end
