module ZenApi
  class Client
    attr_accessor :conn

    def initialize(args = {})
      raise ArgumentError, 'api_key have to be String' unless args[:api_key].is_a?(String)

      options = { :headers => {}}
      options[:url] ||= "https://agilezen.com/api/v1/"
      options[:headers]['X-Zen-ApiKey'] = args[:api_key]

      self.conn ||= Faraday.new(options) do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::Logger
        builder.use Faraday::Adapter::NetHttp
      end
    end
  end

end
