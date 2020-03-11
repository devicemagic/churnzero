require "net/http"

module Churnzero
  class Client
    BASE_URL = "https://analytics.churnzero.net/i"

    def initialize
      @app_key = Churnzero.configuration.app_key
    end

    def post(data = {})
      data = data.merge('appKey' => @app_key).compact
      response = Net::HTTP.post_form(::URI.parse(BASE_URL), data)

      case response
      when Net::HTTPSuccess
        "Request Succeeded"
      else
        "Request Failed"
      end
    end
  end
end
