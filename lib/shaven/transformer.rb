module Shaven
  module Transformer
    require "shaven/transformers/base"
    require "shaven/transformers/dummy"
    require "shaven/transformers/condition"
    require "shaven/transformers/reverse_condition"
    require "shaven/transformers/text_or_node"
    require "shaven/transformers/context"
    require "shaven/transformers/list"
    require "shaven/transformers/auto"

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

    # Returns list of callers with full names. Names are combined with configuration
    # setting in <tt>Shaven.caller_key</tt>.
    def self.callers
      @callers ||= CALLERS.map { |(name,trans)|
        name = [Shaven.caller_key, name].compact.join(':')
        [name,trans]
      }
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
  end # Transformer
end # Shaven
