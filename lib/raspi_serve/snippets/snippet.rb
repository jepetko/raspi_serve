module RaspiServe

  class Snippet
    TARGET_DIR = '/tmp'.freeze

    attr_accessor :code, :file_path

    def initialize(code = nil, file_path = nil)
      @code = code
      @file_path = file_path
    end

    def save
      file_path = File.expand_path(file_name, TARGET_DIR)
      File.write(file_path, code)
      @file_path = file_path
      self
    end

    def load
      @code = File.read(file_path)
    end

    def self.all
      Dir[File.expand_path('snippet-*.rb', TARGET_DIR)].each do |f|
        snippet = Snippet.new nil, f
        snippet.load
      end
    end

    private

    def file_name
      Time.now.strftime('snippet-%Y-%m-%d_%H-%M-%S.rb')
    end

  end

end