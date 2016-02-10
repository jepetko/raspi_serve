require 'fabrication'

Fabricator(:snippet, from: 'RaspiServe::Snippet') do
  code { %q['hello'.reverse] }
  after_create { save }
end