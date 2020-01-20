# frozen_string_literal: true

# Pages controller provides static content.
class PagesController < ApplicationController
  skip_before_action :require_login

  def show; end
end
