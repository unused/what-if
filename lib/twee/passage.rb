# frozen_string_literal: true

module Twee
  class Passage
    attr_reader :id, :type, :tags
    attr_accessor :content

    SPECIAL_TYPES = {
      # TODO: 'StoryCaptions' => :caption, # treat like a prefix
      'StorySettings' => :settings,
      'StoryTitle' => :title,
      'Story Stylesheet' => :styles,
      'Story JavaScript' => :script
    }.freeze

    def initialize(initial_line)
      _line, @id, @tags = self.class.extract_line initial_line
      @content = []
    end

    def self.extract_line(line)
      line.match(/^:: ([\w\s]+)( \[.+\])?$/).to_a.compact.map &:strip
    end

    def special?
      SPECIAL_TYPES.key?(id)
    end

    def type
      SPECIAL_TYPES[id]
    end

    def body
      @content.join("\n").squish
    end

    # Anything inbetween two double square brackets.
    CHOICE_REGEX = /\[{2}[^\]\]]+\]{2}/.freeze

    def choices
      body.scan(CHOICE_REGEX).map { |c| Choice.new(c) }
    end
  end
end
