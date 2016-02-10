require 'spec_helper'

describe RaspiServe::Snippet do

  context 'saving' do
    let(:snippet) { Fabricate(:snippet) }

    it 'references a file path' do
      snippet.file_path.should =~ /\/snippet\-.*\.rb/
    end

    it 'saves a snippet in a file' do
      expect(snippet).to create_a_file('/tmp/snippet-*.rb').in_the_recent_seconds(1)
    end
  end

  context 'listing' do
    before do
      3.times { |i| Fabricate(:snippet, code: %Q[puts "trial#{i}"]) }
    end

    it 'lists all snippets' do
      expect(RaspiServe::Snippet.all.count).to be 3
    end

    it 'lists recent 2 snippets' do
      expect(RaspiServe::Snippet.recent(2).count).to be 2
      expect(RaspiServe::Snippet.recent(2).first.code).to eq 'puts "trail3"'
    end

  end

end