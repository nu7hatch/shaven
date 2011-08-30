module Shaven
  class Transformer
    # Caller key defines access to transformation from your template. Eg. for `Condition`
    # transformer <tt>caller_key = 'if'</tt>, which means that you can define this 
    # transformation using `data-if` html key.
    def self.caller_key
      @caller_key
    end

    # Setter for custom caller key.
    def self.caller_key=(key)
      @caller_key = key.to_s.freeze
    end

    # This key is composed from global caller key (see: Shaven#caller_key_prefix) and 
    # transformers' custom key.
    def self.html_key
      @full_key ||= Shaven.caller_key_prefix + caller_key
    end

    # This is chain containing list of tranformers allowed to call from your templates.
    # All of them will be sequentially applied to each node in your template. Order is 
    # important because some of them allow to keep going with other transformations 
    # after they are applied, other doesn't allow that. 
    def self.transformers_chain
      @transformers_chain ||= [Dummy, Condition, ReverseCondition, Auto]
    end
    
    # Returns list of callers with full names. Names are combined with configuration
    # setting in <tt>Shaven.caller_key</tt>.
    def self.callers
      @callers ||= transformers_chain.map { |trans| [trans.html_key, trans] }
    end

    # Goes through callers chain and tries to apply all matching transformers within
    # given scope. If scope for children should be combined/modified then it returns
    # new scope for later usage, otherwise +nil+ will be returned.
    def self.apply_each(scope, &block)
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
    def self.apply!(scope)
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
    def self.can_be_transformed?(value)
      true
    end

    # Transformers can load values from scope in differen ways, so this method
    # allows to define such own way within each trasformer. By default it just
    # picks up specified key from given scope. 
    def self.find_value(scope, key)
      scope[key]
    end

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
    
    # Load all built-in transformers
    Dir[File.dirname(__FILE__)+"/transformers/*.rb"].each { |transformer|
      require transformer
    }
  end # Transformer
end # Shaven
