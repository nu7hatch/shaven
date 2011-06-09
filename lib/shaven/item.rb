module Shaven
  # Item is used as placeholder for object's additional options while
  # list or scope transformation is being performed.
  #
  # ==== Example
  #
  #   item = Shaven::Item.new("Hello world", 0, lambda { |item,id| return "#{item.dasherize}-#{id}" })
  #   item.id # => 'hello-world-0'
  #   item.to_shaven # => 'Hello world'
  #
  class Item
    # Item is created from given object, optionally we can pass current
    # list index and indexer (lambda for dom id generation within list or
    # scope).
    def initialize(obj, index=nil, indexer=nil)
      @obj, @index, @indexer = obj, index, indexer
    end
    
    # Generates DOM id using previously defined indexer.
    def id
      if @indexer.respond_to?(:call)
        args = []
        args << @obj if @indexer.arity > 0
        args << @index if @index and @indexer.arity > 1
        @indexer.call(*args)
      end
    end
    
    # Returns final value used while transformation. 
    def to_shaven
      @obj.to_shaven
    end

    def to_shaven_item(index=nil, indexer=nil)
      @index = index
      self
    end

    # Always true...
    def shaven_item?
      true
    end
  end # Item
end # Shaven
