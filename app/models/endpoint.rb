# frozen_string_literal: true

# app/models/endpoint.rb
# #TODO: move to constant
class Endpoint < ApplicationRecord
  validates :verb, presence: true, inclusion: { in: %w[GET POST PATCH DELETE] }
  validates :path, presence: true, uniqueness: true
  validates :response_code, presence: true

  before_save :normalize_path_and_verb

  private

  def normalize_path_and_verb
    self.path = path.downcase if path.present?
    self.verb = verb.upcase if verb.present?
  end
end
