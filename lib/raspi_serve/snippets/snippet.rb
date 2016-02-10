module RaspiServe

  class Snippet

    module ClassMethods

      def prefix
        'snippet-'
      end

      def file_pattern
        "#{prefix}*.rb"
      end

      def target_dir
        '/tmp'
      end

      def all
        load_files list_files
      end

      def clear
        list_files.each do |f|
          Snippet.new(nil, f) { |s| s.delete }
        end
      end

      def recent(count)
        load_files list_files.sort_by {|f| File.mtime(f)}.reverse.first(count)
      end

      private

      def list_files
        Dir[File.expand_path("#{prefix}*.rb", target_dir)]
      end

      def load_files(files)
        snippets = []
        files.each do |f|
          snippets << Snippet.new(nil, f) { |s| s.load }
        end
        snippets
      end

    end

    extend ClassMethods

    attr_accessor :code, :file_path

    def initialize(code = nil, file_path = nil, &block)
      @code = code
      @file_path = file_path
      block.call(self) if block_given?
    end

    def save
      file_path = File.expand_path(file_name, self.class.target_dir)
      File.write(file_path, code)
      @file_path = file_path
      self
    end

    def load
      @code = File.read(file_path)
    end

    def delete
      File.delete file_path
    end

    def to_json(state)
      file_path
    end

    private

    def file_name
      Time.now.strftime("#{self.class.prefix}%Y-%m-%d_%H-%M-%S-%L.rb")
    end

  end

end