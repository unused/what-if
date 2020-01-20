# frozen_string_literal: true

# A collection of responses to simplify replacement.
class FriendlyMessages
  MESSAGES = YAML.safe_load File.read Rails.root.join('lib', 'alexa_handler',
                                                      'friendly_messages.yml')

  def self.fetch(*args)
    MESSAGES.fetch String(args.first)
  end
end
