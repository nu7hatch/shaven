module Shaven
  module Transformer
    # Base class for all transformers. All custom transformers should follow this 
    # structure. Check out Shaven's built in transformes to get know what's going on. 
    class Base
      # Name of the presenters method/key from which value has been extracted.
      attr_reader :name
      # Value extracted from presenter. 
      attr_reader :value
      # Transformation context scope.
      attr_reader :scope

      class << self
        # This method contains set of conditions which tells if given value can be 
        # used to transformation on current node. Each transformer should override
        # this method if has such extra requirements. 
        def can_be_transformed?(value)
          true
        end

        # Transformers can load values from scope in differen ways, so this method
        # allows to define such own way within each trasformer. By default it just
        # picks up specified key from given scope. 
        def find_value(scope, key)
          scope[key]
        end
      end # self

      def initialize(name, value, scope)
        @name, @value, @scope = name, value, scope
      end

      # Just shortcut for <tt>scope.node</tt>.
      def node
        scope.node
      end

      # If this method returns +true+ then transformers left in chain gonna be applied 
      # to node within current scope, otherwise transformation chain will be broken.
      # By default continuing after one transformation is not allowed.
      def allow_continue?
        false
      end
      
      # This method should contain all transformation directives. If scope for children
      # nodes should be modified then method should return extra hash/scope which will
      # be temporary combined with current one, otherwise returns +nil+. 
      def transform!
        raise NotImplementedError, "You have to implement #transform! in your transformer"
      end
    end # Base
  end # Transformer
end # Shaven
