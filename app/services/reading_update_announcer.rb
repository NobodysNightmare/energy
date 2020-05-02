# frozen_string_literal: true

class ReadingUpdateAnnouncer
  class << self
    def announce(reading)
      Timeout.timeout(1) do
        GraphiteExporter.default.export(reading)
      end
    rescue Timeout::Error
      nil
    end
  end
end
