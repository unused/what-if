# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    ask_id do
      rand_str = Faker::Alphanumeric.alphanumeric(number: 207).upcase
      "amzn1.ask.account.#{rand_str}"
    end
  end
end
