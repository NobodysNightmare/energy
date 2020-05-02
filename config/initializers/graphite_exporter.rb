# frozen_string_literal: true

hostname = ENV['GRAPHITE_HOST']
port = ENV['GRAPHITE_PORT']

if hostname && port
  GraphiteExporter.default = GraphiteExporter.new(
    hostname,
    port.to_i
  )
end
