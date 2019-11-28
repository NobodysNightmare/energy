class BatterySimulation
  class RollupCollector
    def initialize
      @current_frame = nil
      @frames = []
    end

    def update(time:, **options)
      if @current_frame.nil? || !@current_frame.date_match?(time)
        commit_frame(@current_frame) if @current_frame
        @current_frame = Frame.new(time)
      end

      @current_frame.update(time: time, **options)
      true
    end

    def result
      if @current_frame
        commit_frame(@current_frame)
        @current_frame = nil
      end

      summary = summary_for(@frames)
      Result.new(@frames, summary)
    end

    private

    def commit_frame(frame)
      @frames << frame
    end

    def summary_for(frames)
      summary = Frame.new(nil)
      frames.each do |frame|
        summary.update(time: nil,
                       exported: frame.exported,
                       imported: frame.imported,
                       charged: frame.charged,
                       discharged: frame.discharged,
                       battery: nil)
      end
      summary
    end

    class Frame
      attr_reader :date, :exported, :imported, :charged, :discharged

      def initialize(time)
        @date = reference_date(time) if time
        @exported = 0
        @imported = 0
        @charged = 0
        @discharged = 0
      end

      def update(time:, exported:, imported:, charged:, discharged:, battery:)
        @exported += exported
        @imported += imported
        @charged += charged
        @discharged += discharged
      end

      def date_match?(time)
        @date == reference_date(time)
      end

      def formatted_date
        return '' if date.nil?
        date.strftime('%b %Y')
      end

      private

      def reference_date(time)
        time.beginning_of_month
      end
    end

    Result = Struct.new(:frames, :summary)
  end
end
