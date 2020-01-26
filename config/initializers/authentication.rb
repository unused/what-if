# frozen_string_literal: true

# Register warden authentication
Warden::Strategies.add(:session) do
  def valid?
    session.key? :user
  end

  def authenticate!
    user = User.find session[:user]
    user.nil? ? fail!('Could not log in') : success!(user)
  end
end

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.failure_app = proc { |_env|
    [
      '401',
      { 'Content-Type' => 'application/json' },
      { error: 'Unauthorized', code: 401 }
    ]
  }
  manager.default_strategies :session
end
