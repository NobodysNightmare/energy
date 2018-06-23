# frozen_string_literal: true

class ApiKey < ApplicationRecord
  validates :name, presence: true
  validates :secret, presence: true

  def self.valid?(secret)
    where(secret: secret).exists?
  end
end
