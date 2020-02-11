# frozen_string_literal: true

require Rails.root.join 'lib', 'story_extractor'
require Rails.root.join 'lib', 'story_converter'

# Convert worker preprocesses and persists a story. From file to database
# entry. Note that converted stories always belong to a user.
class ConvertWorker
  include Sidekiq::Worker

  # Helper class to objectify handling.
  class Helper
    def initialize(story_id)
      @story_id = story_id
    end

    def text_filename
      Rails.root.join 'tmp', "#{@story_id}.html"
    end

    def filename
      Rails.root.join 'tmp', "#{@story_id}.tw"
    end

    def story
      @story ||= Story.find @story_id
    end

    def convert_file
      File.write text_filename, story.raw

      Rails.logger.info `pwd`
      Rails.logger.info `ls -al #{Rails.root.join('bin')}`
      `#{tweego} -d #{text_filename} -o #{filename}`
    end

    def tweego
      StoryConverter.executable
    end
  end

  def perform(story_id)
    helper = Helper.new story_id
    helper.convert_file

    StoryExtractor.from_file(helper.filename).parse do |result|
      helper.story.update StoryConverter.build result
    end
  rescue StandardError => e
    Rails.logger.error "[ConvertWorker] Failed to parse #{story_id}, #{e}"
  end
end
