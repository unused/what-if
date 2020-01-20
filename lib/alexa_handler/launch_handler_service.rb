# frozen_string_literal: true

# Handles launch scenarios
class LaunchHandlerService
  def initialize(request, user)
    @request = request
    @user = user
  end

  def update(alexa)
    # TODO: handle launch intent if empty_request?
    return load_game_state alexa if continue?

    alexa.say FriendlyMessages.fetch :welcome
  end

  def continue?
    @user.active_game?
  end

  def load_game_state(alexa)
    alexa.say @user.passage.text
  end
end
