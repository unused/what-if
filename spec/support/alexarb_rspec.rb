# frozen_string_literal: true

module AlexarbRspec
  extend ActiveSupport::Concern

  class RequestBuilder
    def initialize(data)
      @data = data
    end

    def call
      {
        context: {
          system: {
            user: {
              user_id: user_id&.ask_id || FactoryBot.build(:user).ask_id
            }
          }
        },
        request: {
          type: @data[:type]
        }.merge(intent),
        content: @data[:content]
      }.merge content
    end

    def user_id
      @data[:user]
    end

    def content
      return {} unless @data.key? :content

      { content: @data[:content] }
    end

    def intent
      return {} unless @data.key? :intent

      { intent: { name: @data[:intent] }.merge(slots) }
    end

    def slots
      return {} unless @data.key? :slots

      {
        slots: {}.tap do |slots|
          @data[:slots].each_pair { |key, value| slots[key] = { value: value } }
        end
      }
    end
  end

  included do
    attr_reader :response

    def request(opts)
      opts.reverse_merge type: 'IntentRequest', slots: nil
      handle_request Alexarb::Request.new RequestBuilder.new(opts).call
    end

    def handle_request(req)
      @response = Alexarb::Response.new.tap do |res|
        described_class.new(req, res).call
      end
    end

    def expect_alexa
      expect(response.text[:text])
    end

    def say(verification)
      eql verification
    end
  end

  RSpec.configure do |config|
    config.include self, type: :alexarb_application
  end
end
