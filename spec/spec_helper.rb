$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fabricators/snippet_fabricator'
require 'matchers/file_matcher'
require 'raspi_serve'

RSpec.configure do |config|
  config.before(:suite) do
    config.instance_eval do
      def target_dir
        '/tmp'
      end
    end
  end
  config.before(:each) do
  end
end
