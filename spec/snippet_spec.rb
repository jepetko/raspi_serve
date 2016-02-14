require 'spec_helper'

describe RaspiServe::Snippet do

  context 'saving' do
    let(:snippet) { Fabricate(:snippet) }

    it 'has a file name' do
      expect(snippet.file_name).to match %r[snippet\-.*\.rb]
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

  context 'updating' do
    let(:snippet) { Fabricate(:snippet) }
    it 'updates an existing snippet' do
      RaspiServe::Snippet.update('id' => snippet.id, 'code' => %q[puts 'bye bye'])

      expect(RaspiServe::Snippet.recent(1).first.code).to eq %q[puts 'bye bye']
    end
  end

  context 'querying' do

    context 'existing snippet' do
      it 'returns the snippet by id' do
        Fabricate(:snippet, id: 'abc123', code: '3.times {}')
        expect(RaspiServe::Snippet.where(id: 'abc123').first.code).to eq '3.times {}'
      end
    end

    context 'non existing snippet' do
      it 'returns nil' do
        expect(RaspiServe::Snippet.where(id: 'abc123').first).not_to be
      end
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