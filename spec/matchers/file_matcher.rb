require 'rspec/expectations'

RSpec::Matchers.define :create_a_file do |file_pattern|

  match do ||
    files = Dir[file_pattern]
    return false if files.count == 0
    if @seconds
      sample = files.map! {|f| File.mtime(f) }.sort.last
      return false unless (Time.now - sample) < @seconds
    end
    true
  end

  chain :in_the_recent_seconds do |seconds|
    @seconds = seconds
  end

end