# frozen_string_literal: true

require Rails.root.join 'lib', 'story_extractor'
require Rails.root.join 'lib', 'story_converter'

# whatif:convert[path/storyfile.tw] .. parse and persist a story file.
#
# Steps:
#   - Split a story into passages.
#   - Save any special passage content (script, styles) to story meta data.
#   - Extract, cleanup and persist passage contents.
#   - Extract choices and reference with passages.
namespace :whatif do
  desc 'Convert and persist a story file'
  task :convert, [:filename] => :environment do |_task, args|
    puts "Converting file #{args.filename}..."

    StoryExtractor.from_file(args.filename).parse do |result|
      StoryConverter.create result
    end
  end
end
