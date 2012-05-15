require 'faraday_middleware'

module ZenApi
  class Client
    attr_accessor :conn, :schema

    def initialize(args = {})
      raise ArgumentError, 'api_key have to be String' unless args[:api_key].is_a?(String)

      options = { :headers => {}}
      options[:url] ||= "https://agilezen.com/api/v1/"
      options[:headers]['X-Zen-ApiKey'] = args[:api_key]

      self.conn ||= Faraday.new(options) do |conn|
        conn.request :json
        conn.request :url_encoded

        conn.response :json, :content_type => 'application/json'

        conn.adapter :net_http
      end
    end

    def define_schema(args = {}, &block)
      args.merge! :client => self
      self.schema = ZenApi::Schema.new(args, &block)
    end
  end

end
