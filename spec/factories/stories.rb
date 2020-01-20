# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    title { Faker::Games::Zelda.game }

    transient do
      passages_count { 5 }
    end

    # Build a random story with `passages_count` passages.
    after(:create) do |story, evaluator|
      refs = [].tap do |unique_refs|
        while unique_refs.count < evaluator.passages_count
          unique_refs.push(FactoryBot.build(:passage).ref).uniq!
        end
      end

      passages = refs.map do |ref|
        FactoryBot.build :passage, ref: ref, choices: [], story: story
      end

      passages.each do |passage|
        choice_count = [*2..refs.count].sample
        passage.choices = refs.sample(choice_count).map do |ref|
          Choice.new label: ref.titleize, ref: ref
        end
      end

      story.update! passages: passages
    end
  end
end
