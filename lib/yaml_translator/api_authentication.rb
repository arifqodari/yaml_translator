module YAMLTranslator
  class APIAuthentication

    REQUEST_TOKEN_URL = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13'
    API_SCOPE = 'http://api.microsofttranslator.com/'
    GRANT_TYPE = 'client_credentials'

    attr_reader :token
    attr_reader :token_expired

    
    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      request_token
    end

    def valid_token
      if @token_expired < Time.now
        request_token
      end

      return @token
    end

    def request_token
      begin
        response = RestClient.post(REQUEST_TOKEN_URL, request_token_params, :content_type => 'application/x-www-form-urlencoded')

        response = parse_json(response)
        @token = response['access_token']
        @token_expired = Time.now + response['expires_in'].to_i
      rescue Exception => e
        YAMLTranslator::ErrorMessage.show(e)
      end
    end


    private

    def request_token_params
      {
        'client_id' => @client_id,
        'client_secret' => @client_secret,
        'scope' => API_SCOPE,
        'grant_type' => GRANT_TYPE
      }
    end

    def parse_json(string)
      return JSON.parse(string)
    end

  end
end
