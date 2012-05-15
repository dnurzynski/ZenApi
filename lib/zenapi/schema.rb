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
  end
end
