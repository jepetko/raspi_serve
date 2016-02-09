module RaspiServe

  class Snippet
    include Storable

    def initialize(code = nil)
      @code = code
    end
  end

end