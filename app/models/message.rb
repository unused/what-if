# frozen_string_literal: true

# Message represents any Alexa request received by the application.
#
#    field :type, type: String
#    field :data, type: String
class Message < ApplicationRecord
  belongs_to :user

  after_create :broadcast

  def data_json
    self[:data]
  end

  def data
    JSON.parse self[:data] if self[:data].present?
  rescue JSON::ParserError
    { error: 'JSON::ParserError', message: 'Could not parse message' }
  end

  def broadcast
    ActionCable.server.broadcast 'messages', attributes
  end
end
