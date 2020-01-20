# frozen_string_literal: true

require 'rails_helper'

RSpec.feature AlexaHandler, type: :alexarb_application do
  let(:save_game) { FactoryBot.create :save_game }
  let(:user) { save_game.user }
  let(:story) { save_game.story }
  let(:passage) { story.initial }
  let(:passages) { story.passages }

  describe 'LaunchRequest' do
    it 'ask for story' do
      request type: 'LaunchRequest'

      expect_alexa.to include 'Nice you joined.'
    end

    it 'responds with recent passage' do
      request type: 'LaunchRequest', user: user

      expect_alexa.to say passage.body
    end
  end

  describe 'SessionEndedRequest' do
    it 'should gracefully respond to' do
      request type: 'SessionEndedRequest'
      expect(response.text[:text]).to be_empty
    end
  end

  describe 'ListChoicesIntent' do
    it 'lists all choices' do
      request type: 'IntentRequest', intent: 'ListChoicesIntent',
              user: user

      out = passage.choices.each_with_index.map do |choice, index|
        "#{(index + 1).ordinalize} #{choice}"
      end.to_sentence last_word_connector: ' or '

      expect_alexa.to say out
    end
  end

  describe 'LoadStoryIntent' do
    let(:new_story) { FactoryBot.create :story }

    it 'choose a new story' do
      request type: 'IntentRequest', intent: 'LoadStoryIntent',
              user: user, slots: { story: new_story.title }

      expect_alexa.to say new_story.initial.body
    end

    it 'chooses a random story' do
      request type: 'IntentRequest', intent: 'LoadStoryIntent',
              user: user, slots: { story: 'random story' }

      expect_alexa.not_to include 'I could not find a matching story'
    end

    it 'chooses a random story' do
      request type: 'IntentRequest', intent: 'LoadStoryIntent',
              user: user, slots: { story: 'foobar' }

      expect_alexa.to include 'I could not find a matching story'
    end
  end

  describe 'ChooseIntent' do
    context 'with ordinal slot' do
      let(:decision) { [*0...passage.choices.count].sample }

      it 'chooses correct passage' do
        request type: 'IntentRequest', intent: 'ChooseIntent',
                slots: { decision: (decision + 1).ordinalize }, user: user

        selected = passages.find_by ref: passage.choices[decision].ref
        expect_alexa.to say selected.body
      end
    end

    context 'with query slot' do
      let(:choice) { passage.choices.sample }
      let(:query) { choice.label }

      it 'chooses correct passage' do
        request type: 'IntentRequest', intent: 'ChooseIntent', user: user,
                slots: { query: query }

        new_passage = passages.find_by ref: choice.ref
        expect_alexa.to say new_passage.body
      end
    end
  end

  describe 'AMAZON.RepeatIntent' do
    it 'repeats current passage' do
      request type: 'IntentRequest', intent: 'AMAZON.RepeatIntent', user: user

      expect_alexa.to say passage.body
    end
  end

  describe 'LoginIntent' do
    it 'provides a passcode for login' do
      request type: 'IntentRequest', intent: 'LoginIntent', user: user

      code = Passcode.last.code.chars.join ', '
      expect_alexa.to say "Use the following code: #{code}"
    end
  end
end
