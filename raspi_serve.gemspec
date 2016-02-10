# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raspi_serve/version'

Gem::Specification.new do |spec|
  spec.name          = "raspi_serve"
  spec.version       = RaspiServe::VERSION
  spec.authors       = ["katarina golbang"]
  spec.email         = ["golbang.k@gmail.com"]

  spec.summary       = %q{Simple Server for accepting client requests. Even if it can run on any operating system it's actually intended to be executed on Raspberry Pi.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["raspi_serve"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "warden", "~> 1.2.6"
  spec.add_runtime_dependency "puma", "~> 2.15.3"
  spec.add_runtime_dependency "rack-cors", "~> 0.4.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "debase", "~> 0.2.1"
  spec.add_development_dependency "fabrication", "~> 2.13.2"
  spec.add_development_dependency "capybara", "~> 2.6.2"
end
