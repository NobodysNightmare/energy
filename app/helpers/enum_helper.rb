# frozen_string_literal: true

module EnumHelper
  def enum_options(model, enum_field, selected)
    enum = model.public_send(enum_field.to_s.pluralize)
    options_for_select(
      enum.keys.map do |identifier|
        [
          I18n.t("enums.#{model.to_s.downcase}.#{enum_field}.#{identifier}"),
          identifier
        ]
      end,
      selected
    )
  end
end
