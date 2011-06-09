require 'shaven/transformers/content'
module Shaven
  module Transformer
    class List < Content
      def can_be_transformed?
        # Can be applied with arrays. 
        super && subst_value.is_a?(Array)
      end

      def allow_continue?
        false
      end

      # Default indexer is an lambda which generates sequentional dom id's for
      # each list elements. Such indexers can be supplied by substitution objects
      # as well.
      def default_indexer
        lambda { |item, id| return "#{normalized_name.singularize}_#{id}" }
      end

      def auto_normalize?
        # We don't need normalization on that level...
        false
      end

      def transform!
        index = 0

        subst_value.each { |item|
          item = item.to_shaven_item(index+=1, default_indexer)
          array_scope = combine_scope(scope, { subst_name => item })
          new_node = node.dup
          
          if transformer = self.class.transform_node(new_node, array_scope)
            new_node = node.add_previous_sibling(transformer.result) if transformer.result
            self.class.transform_children(new_node, transformer.scope)
          end
        }

        node.remove
      end
    end # List
  end # Transformer
end # Shaven