# frozen_string_literal: true

module TimelineHelper
  def timeline_period_options(selected = nil)
    options = [''] + SiteTimeline::PERIOD_DURATIONS.keys
    options_for_select(
      options.map do |identifier|
        [
          I18n.t("timeline.periods.#{identifier.presence || 'none'}"),
          identifier
        ]
      end,
      selected
    )
  end
end
