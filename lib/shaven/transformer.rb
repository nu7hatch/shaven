module Shaven
  class Transformer
    # Just sugar to not using <tt>self</tt> in inheritance definition. 
    Base = self

    # Load all built-in transformers
    Dir[File.dirname(__FILE__)+"/transformers/*.rb"].each { |transformer|
      require transformer
    }

    # This is chain containing list of DOM caller arguments and related transformers.
    # All of them will be sequentially applied to each node in your template. Order is 
    # important because some of them allow to keep going with other transformations 
    # after they are applied, other doesn't allow that. 
    CALLERS = [
      ['dummy',  Dummy],
      ['if',     Condition],
      ['unless', ReverseCondition],
      [nil,      Auto]
    ]

    class << self
      # Returns list of callers with full names. Names are combined with configuration
      # setting in <tt>Shaven.caller_key</tt>.
      def callers
        @callers ||= CALLERS.map { |(name,trans)|
          name = [Shaven.caller_key, name].compact.join(':')
          [name,trans]
        }
      end

      # Goes through callers chain and tries to apply all matching transformers within
      # given scope. If scope for children should be combined/modified then it returns
      # new scope for later usage, otherwise +nil+ will be returned.
      def apply_each(scope, &block)
        callers.each { |(name,trans)|
          if key = scope.node.delete(name)
            value = trans.find_value(scope, key).to_shaven
            
            if trans.can_be_transformed?(value)
              transformer = trans.new(key, value, scope)
              extra_scope = transformer.transform!
              return extra_scope unless transformer.allow_continue?
            end
          end
        }
        nil
      end

      # Applies each transformers within scope, to all children of represented document's 
      # node. Transformations are applied only for element nodes.
      def apply!(scope)
        scope.node.children.each { |child|
          if child.elem?
            extra_scope = apply_each(scope.with(child))
            scope.unshift(extra_scope) if extra_scope
            apply!(scope)
            scope.shift if extra_scope
          end
        }
        nil
      end

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

    # Name of the presenters method/key from which value has been extracted.
    attr_reader :name
    # Value extracted from presenter. 
    attr_reader :value
    # Transformation context scope.
    attr_reader :scope

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
  end # Transformer
end # Shaven
