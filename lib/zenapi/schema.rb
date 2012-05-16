module ZenApi
  class Schema
    attr_accessor :path, :paths, :name

    def initialize(args = {}, &block)
      @path        = args[:path]   || ""
      @paths       = args[:paths]  || {}
      @tokens      = []

      instance_eval &block if block_given?
      self
    end

    #
    # DSL methods
    #
    def resource name, args = {}, &block
      define_path name, args, &block
    end

    def resources name, args = {}, &block
      child = define_path name, args
      show = child.define_path :show, :path => ':id'
      show.instance_eval &block if block_given?
    end

    def define_path name, args = {}, &block
      args[:path]   ||= name.to_s

      child = @paths[name] = Schema.new args
      child.instance_eval &block if block_given?
      child
    end


  end
end
