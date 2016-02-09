module RaspiServe

  module Storable
    TARGET_DIR = '/tmp'.freeze

    attr_accessor :code

    def save
      File.write(File.expand_path(file_name, TARGET_DIR), code)
      self
    end

    private

    def file_name
      Time.now.strftime('snippet-%Y-%m-%d_%H-%M-%S.rb')
    end

  end

end