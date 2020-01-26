# frozen_string_literal: true

require_relative './alexa_handler/user_choice_select_service'
require_relative './alexa_handler/launch_handler_service'
require_relative './alexa_handler/load_story_service'
require_relative './alexa_handler/choices_list'
require_relative './alexa_handler/story_recommender'
require_relative './alexa_handler/friendly_messages'

# AlexaHandler responds to Alexa requests.
class AlexaHandler < Alexarb::Application
  def initialize(*args)
    super(*args)

    # Overwrite response defaults
    @response.keep_session = true
  end

  attr_reader :user
  delegate :story, to: :user
  delegate :passage, to: :user

  before_filter do
    @user ||= User.find_or_create_by ask_id: jeff.whoami
    msg = user.messages.new(data_type: 'request', data: request.raw.to_json)
    Rails.env.production? ? msg.broadcast : msg.save!
  end

  after_filter do
    msg = user.messages.new(data_type: 'response', data: response.to_h.to_json)
    Rails.env.production? ? msg.broadcast : msg.save!
  end

  launch_request do
    LaunchHandlerService.new(request, user).update alexa
  end

  intent 'AMAZON.ReadIntent' do
    alexa.say passage.text
  end

  intent 'AMAZON.RepeatIntent' do
    alexa.say passage.text
  end

  intent 'AMAZON.StopIntent' do
    response.keep_session = false
  end

  intent 'AMAZON.NavigateHomeIntent' do
    response.keep_session = false
  end

  intent 'AMAZON.HelpIntent' do
    alexa.say FriendlyMessages.fetch :help
  end

  intent 'LoginIntent' do
    passcode = Passcode.create!(user: user).code
    alexa.say "Use the following code: #{passcode.chars.join(', ')}"
    # alexa.use_ssml = true
    # alexa.say '<speak>' + FriendlyMessages.fetch(:login) \
    #   + %(<say-as interpret-as="digits">#{passcode}</say-as>).html_safe \
    #   + '</speak>'
  end

  intent 'LoadStoryIntent' do
    service = LoadStoryService.new request

    unless service.found?
      alexa.say FriendlyMessages.fetch :nostory
      alexa.say StoryRecommender.tell
      next
    end

    service.update user
    alexa.say passage.text
  end

  intent 'ListChoicesIntent' do
    alexa.say ChoicesList.new(passage.choices).to_s
  end

  # TODO: rename decision into ordinal
  intent 'ChooseIntent' do
    current_ref = passage.ref
    UsersChoiceSelectService.new(user).call jeff

    if current_ref == passage.ref
      alexa.say FriendlyMessages.fetch :nochoice
      alexa.say ChoicesList.new(passage.choices).to_s
      next
    end

    alexa.say passage.text
  end

  # intent 'ListStoriesIntent'
  # intent 'SearchStoriesIntent'
  # intent 'RestartStoryIntent'
end
