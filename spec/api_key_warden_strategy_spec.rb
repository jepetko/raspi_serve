require 'spec_helper'
require 'rack'

describe RaspiServe::ApiKeyWardenStrategy do

  let(:app) { proc { |env| [200, {}, ['OK']] } }
  let(:warden) do
    described_class.register_on_warden
    Warden::Manager.new(app) do |mng|
      mng.failure_app = [401, {'Content-Type' => 'text/html'}, ['Not Authorized']]
      mng.default_strategies described_class.identifier
    end
  end

  context 'valid key provided' do

    let(:env) { Rack::MockRequest.env_for('/').merge({'HTTP_API_KEY' => '123'}) }

    it 'authorizes the caller' do
      warden.call env
      user = env['warden'].authenticate
      expect(user).to be_instance_of(RaspiServe::User)
    end
  end

  context 'invalid key provided' do

    let(:env) { Rack::MockRequest.env_for('/').merge({'HTTP_API_KEY' => 'invalid'}) }

    it 'returns no user' do
      warden.call env
      user = env['warden'].authenticate
      expect(user).to be_nil
    end
  end

  context 'no key provided' do

    let(:env) { Rack::MockRequest.env_for('/') }

    it 'returns no user' do
      warden.call env
      user = env['warden'].authenticate
      expect(user).to be_nil
    end
  end

end