# frozen_string_literal: true

# Application Base Controller
class ApplicationController < ActionController::Base
  # include RailsWarden::Authentication

  before_action :require_login

  class FileSizeLimitError < StandardError; end # :nodoc:

  rescue_from 'FileSizeLimitError' do
    head :request_entity_too_large
  end

  rescue_from 'Mongoid::Errors::DocumentNotFound' do |exception|
    session.clear

    raise exception
  end

  private

  def require_login
    redirect_to new_session_path unless authenticated?
  end
end
