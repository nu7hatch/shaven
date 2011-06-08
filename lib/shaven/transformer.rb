module Shaven
  module Transformer
    def self.transform(node, scope)
      node.children.each { |child|
        if child.elem?
          if child['rb']
            result, local = transform_node(child, scope) 
            child.replace(result) unless child.replace_with?(result)
          end

          transform(child, local ? local : scope)
        end
      }
    end

    def self.transform_node(origin, scope)
      subst = scope[param = origin.delete('rb').to_s]
      subst = call_subst(subst, origin) if subst.respond_to?(:call)

      if subst.is_a?(Array)
        [fill_in_with_array(origin, subst), nil]
      elsif replaceable?(subst, origin)
        [subst, nil]
      elsif scopeable?(subst)
        [origin, combine_scope(scope, subst)]
      else
        [origin.update! { subst }, nil]
      end
    end

    def self.call_subst(subst, *args)
      arity = subst.respond_to?(:arity) ? subst.arity : args.size
      args = arity == args.size ? args : [] 
      subst.call(*args)
    end

    def self.fill_in_with_array(origin, subst)
      ""
    end

    def self.scopeable?(subst)
      subst.is_a?(Hash) or subst.respond_to?(:to_shaven)
    end

    def self.replaceable?(subst, origin)
      subst.is_a?(Nokogiri::XML::Node) and subst.replace_with?(origin)
    end

    def self.combine_scope(scope, subst)
      subst = subst.respond_to?(:to_shaven) ? subst.to_shaven : subst
      scope = scope.dup
      scope.unshift(subst.stringify_keys)
    end
  end # Transformer
end # Shaven
