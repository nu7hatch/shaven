module Shaven
  module Transformer
    # Base class for all transformers. All custom transformers should follow this structure.
    # Check out Shaven's built in transformes to get know what's going on. 
    class Base
      class << self
        # Applies transformations to all children of given node, within specified
        # context scope. 
        def transform_children(node, scope)
          node.children.each { |child|
            next unless child.elem?
            transformer = transform_node(child, scope)
            transform_children(child, transformer ? transformer.scope : scope)
          }
        end

        # Applies transformations to single node within given scope. If any transformation
        # could be performed then returns transformer object, otherwise +nil+ will be returned.
        def transform_node(origin, scope)
          CHAIN.each { |klass|
            transformer = klass.new(origin, scope) 
            
            if transformer.can_be_transformed?
              transformer.normalize! if transformer.auto_normalize?
              transformer.transform!
              
              if result = transformer.result and !origin.replace_with?(result)
                # Yeah, it has to be unless here... it's obvious isn't it :)?
                origin.replace(result)
              end

              return transformer unless transformer.allow_continue?
            end
          }

          nil
        end
      end # self

      # Original node to apply tranformations on it.
      attr_reader :node
      # Transformation context scope. 
      attr_reader :scope
      # Transformation result. 
      attr_reader :result

      def initialize(node, scope)
        @node, @scope, @result = node, scope, nil
      end

      # This method should contain transformation conditions. 
      def can_be_transformed?
        rails NotImplementedError, "You have to implement #can_be_transformed? in your transformer"
      end

      # This method tells if transformer allows to continue transfromations with
      # next transfromers left in chain.
      def allow_continue?
        rails NotImplementedError, "You have to implement #allow_continue? in your transformer"
      end
      
      # This method should contain all transformation directives. Remember to store +result+
      # and eventually modified +scope+ for children here. 
      def transform!
        rails NotImplementedError, "You have to implement #transform! in your transformer"
      end
      
      # Normalization is executed before transformation and cleans up shaven directives from
      # transformated node.
      def normalize!
        rails NotImplementedError, "You have to implement #normalize! in your transformer"
      end

      # Set it to +false+ when auto normalization should be disabled within you transformer. 
      def auto_normalize?
        true
      end
    end # Base
  end # Transformer
end # Shaven
