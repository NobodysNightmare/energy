# frozen_string_literal: true

namespace :graphite do
  desc 'Exports all readings to Graphite'
  task export_all: :environment do
    Reading.includes(meter: :site).in_batches(of: 100) do |batch|
      GraphiteExporter.default.export(batch)
    end
  end
end
