module Shaven
  # Special kind of array to fetch data from stack of context scopes.
  #
  # ==== Example
  #
  #   scope = Scope.new({:foo => nil})
  #   scope["foo"] # => nil
  #   scope.unshift({"foo" => "Bar!", "spam" => "Eggs!"})
  #   scope["foo"] # => "Bar!"
  #   scope.unshift({"foo" => "Foobar!"})
  #   scope["foo"] # => "Foobar!"
  #
  class Scope < Array
    # DOM node wrapped by this scope. 
    attr_reader :node

    def initialize(*args)
      super(args)
    end

    def [](key)
      each { |scope|
        if scope.key?(key = key.to_s) 
          value = scope[key]
          
          if value.is_a?(Proc) or value.is_a?(Method)
            args = [node, self]
            return value.call(*args.take(value.arity))
          else
            return value
          end
        end
      }
    end

    # Assigns given DOM node to this context and returns itself. This method will
    # be used to fast switch from one node into another while transformation process.
    #
    # ==== Example
    #
    #   node_scope = scope.with(node)
    #   node_scope.unshift({"foo" => proc { |node| node.update! :id => "hello-node" }})
    #   node_scope["foo"] # => node
    #
    def with(node)
      @node = node
      return self
    end
  end # Scope
end # Shaven
