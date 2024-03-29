module ZenApi
  class Call
    attr_accessor :schema, :client

    def initialize args = {}
      @schema = args[:schema]
      @client = args[:client]
      @path   = [@schema.path]
    end

    def process schema, args = {}
      @schema = schema
      @path << schema.path

      params = {}
      case args
      when Fixnum
        params[:id] = args
      when Hash
        params.merge! args
      end

      @path.each_with_index do |token, i|
        params = params.inject({}) {|sum,array| sum.merge({array[0].to_s => array[1]}) }
        if token =~ /:\w+/
          token = token.clone.gsub!(/^:/,'')
          @path[i] = params[token] if params.keys.map(&:to_s).include? token
        end
      end

      self
    end

    def path
      @path.reject{|p| p.nil? || p == "" }.join('/')
    end

    def execute method_sym, args = {}
      client.conn.send(method_sym, path, args).body
    end

    def method_missing method_sym, *args, &block
      super
    rescue NoMethodError
      if schema.paths.include? method_sym
        process schema.paths[method_sym], *args
      elsif schema.requests.keys.include? method_sym
        execute schema.requests[method_sym], *args
      else
        raise NoMethodError, "Udefined path - '#{method_sym}'"
      end
    end
  end
end
