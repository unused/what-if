require Rails.root.join 'lib', 'twee'
require 'parslet/graphviz'

# twee:parser:print .. print parser graph
namespace :twee do
  namespace :parser do
    desc 'Print Twee parser graph'
    task print: :environment do
      filename = Rails.root.join 'tmp', 'parser-graph.pdf'
      Twee::Parser.graph pdf: filename
      puts "Parser graph saved to #{filename}"
    end
  end
end
