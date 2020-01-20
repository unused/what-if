# frozen_string_literal: true

# Sessions Controller handles user login and logout.
class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  before_action :set_user, only: :create

  def new; end

  def create
    if @user
      sign_in
      redirect_to root_path
    else
      redirect_to new_session_path, alert: t('.error')
    end
  end

  def destroy
    logout

    redirect_to new_session_path
  end

  private

  def set_user
    @user = Passcode.where(code: params.require(:code)).first&.user
  end

  def sign_in
    session[:user] = String(@user.id)
    authenticate
    Passcode.where(user: @user).destroy_all
  end
end
