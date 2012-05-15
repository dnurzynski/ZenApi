module ZenApi
  class Call
    attr_accessor :schema, :api

    def initialize args = {}
      @schema = args[:schema]
      @api    = args[:api]
      @path   = [@schema.path]
    end

    def process schema
      @schema = schema
      @path << schema.path
      self
    end

    def path
      @path.join('/')
    end

    def method_missing method_sym, *args, &block
      super
    rescue NoMethodError
      if schema.paths.include? method_sym
        process schema.paths[method_sym]
      else
        raise NoMethodError, "Udefined path - '#{method_sym}'"
      end
    end

  end
end
