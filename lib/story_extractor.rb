# frozen_string_literal: true

require_relative './twee'

# StoryExtractor extracts story contents from a Twee file.
class StoryExtractor
  def initialize(content = '')
    @content = content
    @result = defaults
  end

  def self.from_file(filename)
    new File.read(filename)
  end

  def parse
    @content.each_line { |line| parse_line line.squish }

    yield @result
  end

  def parse_line(line)
    if line.start_with? '::'
      init_passage line
    else
      @current_passage.content << line
    end
  end

  def defaults
    {
      title: '',
      styles: '',
      script: '',
      settings: '',
      passages: []
    }
  end

  def init_passage(line)
    record_passage if @current_passage
    @current_passage = Twee::Passage.new line
  end

  def record_passage
    if @current_passage.special?
      @result[@current_passage.type] = @current_passage.body
    else
      @result[:passages] << @current_passage
    end
  end
end
