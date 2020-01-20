# Converts content to some story.
class StoryConverter
  def self.create(result)
    Story.create! build result
  end

  def self.build(result)
    result[:passages].map! do |passage|
      choicify = proc { |c| Choice.new label: c.label, ref: c.id }
      Passage.new ref: passage.id, body: passage.body,
                  choices: passage.choices.map(&choicify)
    end

    result
  end

  def self.executable
    ENV.fetch 'TWEEGO_BIN', '/opt/tweego/tweego'
  end
end
