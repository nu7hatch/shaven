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
    def [](key)
      each { |layer| return layer[key.to_s] if layer.key?(key.to_s) }
    end

    def unshift(scope, name=nil)
      chain << name if name
      super(scope)
    end

    # Returns scope names chain.
    def chain
      @chain ||= []
    end

    def dup
      new_scope = super
      new_scope.instance_variable_set("@chain", chain.dup)
      new_scope
    end
  end # Scope
end # Shaven
