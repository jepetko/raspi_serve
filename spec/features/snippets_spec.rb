require 'spec_helper'

feature 'client works with snippets' do

  scenario 'list snippets' do
    visit '/snippets'
    expect(page).to have_content('Hello world')
  end

end