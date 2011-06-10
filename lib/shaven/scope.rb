module Shaven
  # Special kind of array to fetch data from stack of context scopes.
  #
  # ==== Example
  #
  #   scope = Scope.new
  #   scope.unshift({"foo" => "Bar!", "spam" => "Eggs!"})
  #   scope["foo"] # => "Bar!"
  #   scope.unshift({"foo" => "Foobar!"})
  #   scope["foo"] # => "Foobar!"
  #
  class Scope < Array
    attr_reader :node

    def initialize(base)
      super([base])
    end

    def [](key)
      each { |scope|
        if scope.key?(key = key.to_s) 
          value = scope[key]
          
          if value.is_a?(Proc) or value.is_a?(Method)
            return value.call(*(value.arity == 1 ? [node] : []))
          else
            return value
          end
        end
      }
    end

    def with(node)
      @node = node
      return self
    end
  end # Scope
end # Shaven
