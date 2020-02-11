# frozen_string_literal: true

# tweego:setup .. setup tweego in vendor path
#
# Steps:
#   - download tweego release (linux64 via wget)
#   - make directory vendor/tweego
#   - unzip into tmp directory
#   - move story-formats into vendor/tweego
#   - move executable to bin/
namespace :tweego do
  VERSION = '2.1.0'
  ARCH = 'linux-x64'
  SOURCE = "https://github.com/tmedwards/tweego/releases/download/v#{VERSION}/tweego-#{VERSION}-#{ARCH}.zip"

  desc 'Setup tweego'
  task setup: :environment do
    system <<~EOSH
      mkdir -p #{Rails.root.join('tmp', 'tweego')}
      cd #{Rails.root.join('tmp', 'tweego')}
      wget -O tweego.zip -q #{SOURCE}
      unzip -n tweego.zip
      mv tweego #{Rails.root.join('bin')}
      mkdir -p #{Rails.root.join('vendor', 'tweego')}
      mv storyformats #{Rails.root.join('vendor', 'tweego')}
      cd -
      rm -r #{Rails.root.join('tmp', 'tweego')}
    EOSH
  end
end
