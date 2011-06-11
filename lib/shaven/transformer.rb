module Shaven
  module Transformer
    require "shaven/transformers/base"
    require "shaven/transformers/dummy"
    require "shaven/transformers/condition"
    require "shaven/transformers/reverse_condition"
    require "shaven/transformers/text_or_node"
    require "shaven/transformers/hash"
    require "shaven/transformers/list"
    require "shaven/transformers/auto"

    # This is chain containing list of DOM caller arguments and related transformers.
    # All of them will be sequentially applied to each node in your template. Order is 
    # important because some of them allow to keep going with other transformations 
    # after they are applied, other doesn't allow that. 
    CALLERS = [
      ['rb:dummy',  Dummy],
      ['rb:if',     Condition],
      ['rb:unless', ReverseCondition],
      ['rb',        Auto]
    ]

    # Goes through callers chain and tries to apply all matching transformers within
    # given scope. If scope for children should be combined/modified then it returns
    # new scope for later usage, otherwise +nil+ will be returned.
    def self.apply_each(scope, &block)
      CALLERS.each { |(name,trans)|
        if key = scope.node.delete(name)
          value = trans.find_value(scope, key)
          
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
