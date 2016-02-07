require 'warden'

module RaspiServe

  class User
  end

  class ApiKeyWardenStrategy < ::Warden::Strategies::Base

    def self.identifier
      'api_key_auth'
    end

    def self.register_on_warden
      Warden::Strategies.add identifier, self
    end

    def valid?
      env['HTTP_API_KEY']
    end

    def authenticate!
      if env['HTTP_API_KEY'] != '123'
        fail!('Api key not provided')
      else
        success! User.new, 'OK'
      end
    end
  end
end