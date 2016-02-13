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

      def create(params)
        Snippet.new(params['code']).save
      end

      def update(params)
        snippet = Snippet.where(id: params['id']).first
        snippet.code = params['code']
        snippet.save
      end

      def where(params)
        return nil unless files = Dir[File.expand_path("#{prefix}*#{params[:id]}.rb", target_dir)]
        load_files files
      end

      def list_files
        Dir[File.expand_path("#{prefix}*.rb", target_dir)]
      end

      private

      def load_files(files)
        snippets = []
        files.each do |f|
          snippets << Snippet.new(nil, f) { |s| s.load }
        end
        snippets
      end

    end

    extend ClassMethods

    attr_accessor :id, :code, :file_name

    def initialize(code = nil, file_name = nil, &block)
      @code = code
      @file_name = file_name
      @id = @file_name.match(/(?<=\-)[a-z0-9]+(?=\.rb)/)[0] if @file_name
      block.call(self) if block_given?
    end

    def save
      @file_name ||= build_file_name
      File.write(file_path, @code)
      self
    end

    def load
      @code = File.read(file_path)
    end

    def delete
      File.delete file_path
    end

    def to_json(state)
      {id: id}.to_json
    end

    def id
      @id ||= SecureRandom.hex
    end

    private

    def build_file_name
      Time.now.strftime("#{self.class.prefix}%Y-%m-%d_%H-%M-%S-#{id}.rb")
    end

    def file_path
      File.expand_path(@file_name, self.class.target_dir)
    end

  end

end