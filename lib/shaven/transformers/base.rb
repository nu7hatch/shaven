module Shaven
  module Transformer
    class Base
      class << self
        def transform_all(node, scope)
          node.children.each { |child|
            next unless  child.elem?
            
            if child.key?('rb') and !child['rb'].empty?
              result, local = transform_node(child, scope) 
              child.replace(result) unless child.replace_with?(result)
            end
          
            transform_all(child, local ? local : scope)
          }
        end

        def transform_node(origin, scope)
          subst = scope[param = origin.delete('rb').to_s]
          subst = call_subst(subst, origin) if subst.respond_to?(:call)

          CHAIN.each { |transformer_klass|
            transformer = transformer_klass.new(origin, subst, scope)
            return transformer.transform if transformer.can_be_transformed?
          }
        end

        protected

        def call_subst(subst, *args)
          arity = subst.respond_to?(:arity) ? subst.arity : args.size
          args = arity == args.size ? args : [] 
          subst.call(*args)
        end
      end

      attr_reader :node, :subst, :scope

      def initialize(node, subst, scope)
        @node, @subst, @scope = node, subst, scope
      end

      def can_be_transformed?
        rails NotImplementedError, "You have to implement #can_be_transformed? in your transformer"
      end

      def transform
        rails NotImplementedError, "You have to implement #transform in your transformer"
      end

      protected

      def combine_scope(scope, subst)
        subst = subst.respond_to?(:to_shaven) ? subst.to_shaven : subst
        scope = scope.dup
        scope.unshift(subst.stringify_keys)
      end
    end # Base
  end # Transformer
end # Shaven
