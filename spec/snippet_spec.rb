require 'spec_helper'

describe RaspiServe::Snippet do

  context 'saving' do
    let(:snippet) { Fabricate(:snippet) }

    it 'references a file path' do
      expect(snippet.file_path).to match /\/snippet\-.*\.rb/
    end

    it 'saves a snippet in a file' do
      expect(snippet).to create_a_file('/tmp/snippet-*.rb').in_the_recent_seconds(1)
    end

    it 'sets an id' do
      expect(snippet.id).to be
    end
  end

  context 'creating' do

    it 'creates a snippet' do
      expect { RaspiServe::Snippet.create(code: %q[puts 'hello']) }.to change { RaspiServe::Snippet.list_files.count }.by(1)
    end
  end

  context 'listing' do
    before do
      3.times do |i|
        Fabricate(:snippet, code: %Q[puts "trial#{i}"])
        sleep 0.2
      end
    end

    it 'lists all snippets' do
      expect(RaspiServe::Snippet.all.count).to be 3
    end

    it 'lists recent 2 snippets' do
      expect(RaspiServe::Snippet.recent(2).count).to be 2
      expect(RaspiServe::Snippet.recent(2).first.code).to eq 'puts "trial2"'
    end

  end

end