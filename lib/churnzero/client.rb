module Churnzero
  class Client
    BASE_URL = "https://analytics.churnzero.net/i"

    def initialize
      @app_key = Churnzero.configuration.app_key
    end

    def post(data = {})
      validate

      data = data.merge('appKey' => @app_key).compact
      response = Net::HTTP.post_form(::URI.parse(BASE_URL), data)

      case response
      when Net::HTTPSuccess
        true
      else
        false
      end
    end

    private

      def validate
        raise Error.new("Churnzero.configuration.app_key is nil") if @app_key.nil?
      end

  end
end
