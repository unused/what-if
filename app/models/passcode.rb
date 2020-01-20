# frozen_string_literal: true

# Passcode provides a temporary login credential linked to a user.
#
#   field :code, type: String
class Passcode < ApplicationRecord
  belongs_to :user

  validates :user, presence: true, uniqueness: true

  # TODO: index({ code: 1 }, unique: true)
  # TODO: index({ created_at: 1 }, expire_after_seconds: 5.minutes)

  attr_readonly :code

  before_create do
    loop do
      self.code = 10_000 + SecureRandom.random_number(89_999)
      break unless Passcode.where(code: code).exists?
    end
  end
end
