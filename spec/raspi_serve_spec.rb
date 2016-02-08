require 'spec_helper'

describe RaspiServe do

  let(:app) { RaspiServe.create_rack_app }

  it 'provides a rack app' do
    expect(app).to be
  end

  it 'uses CORS middleware to allow cross origin requests' do
    middleware = [app]
    while ((next_app = middleware.last.instance_variable_get(:@app)) != nil)
      middleware << next_app
    end
    middleware.map! {|m| m.class }
    expect(middleware).to include(Rack::Cors)
  end

  it 'allows cross origin request' do
    req = Rack::MockRequest.new(app)
    resp = req.get('/', {'HTTP_API_KEY' => '123', 'HTTP_ORIGIN' => '*'})

    expect(resp.headers).to have_key('Access-Control-Allow-Origin')
    expect(resp.headers['Access-Control-Allow-Origin']).to eq('*')
  end

end
