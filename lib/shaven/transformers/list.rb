module Shaven
  module Transformer
    class List < Base
      def can_be_transformed?
        subst.is_a?(Array)
      end

      def transform
        subst.each { |item|
          new_node = node.dup
          array_scope = { node['rb'].to_s => item }
          result, local_scope = self.class.transform_node(new_node, combine_scope(scope, array_scope))
          new_node = node.add_previous_sibling(result)
          self.class.transform_all(new_node, local_scope)
        }
        node.remove
      end
    end # List
  end # Transformer
end # Shaven
