module ZenApi
  class Schema
    attr_accessor :client, :path, :paths, :name

    def initialize(args = {}, &block)
      @client      = args[:client]
      @path        = args[:path]   || ""
      @paths       = args[:paths]  || {}

      instance_eval &block if block_given?
      self
    end

    #
    # DSL methods
    #
    def resource name, args = {}, &block
      args[:client]   = client
      args[:path]   ||= name.to_s

      child = @paths[name] = Schema.new args
      child.instance_eval &block if block_given?
      self
    end

    def resources name, args = {}, &block
      resource name, args, &block
    end

  end
end
