# frozen_string_literal: true

class ApiKey < ApplicationRecord
  validates :access_token, presence: true, uniqueness: true
  validates :name, presence: true

  before_validation :generate_access_token, on: :create

  private

  def generate_access_token
    self.access_token ||= SecureRandom.hex(20)
  end
end
