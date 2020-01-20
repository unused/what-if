# frozen_string_literal: true

# Messages controller provides recent received and sent messages.
class MessagesController < ApplicationController
  def index
    render status: :ok, json: recent_messages
  end

  private

  def recent_messages
    user.messages.order(created_at: :desc).limit 10
  end
end
