require 'spec_helper'

describe RaspiServe::Snippet do

  context 'saving' do
    let(:snippet) { Fabricate(:snippet) }

    it 'saves a snippet in a file' do
      expect(snippet.save).to create_a_file('/tmp/snippet-*.rb').in_the_recent_seconds(1)
    end
  end

  context 'listing' do
    before do
      Fabricate(3, :snippet)
    end

    it 'lists all snippets' do
      expect(Snippet.all).to eq []
    end

  end

end