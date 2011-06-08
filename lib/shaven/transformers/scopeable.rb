module Shaven
  module Transformer
    class Scopeable < Base
      def can_be_transformed?
        subst.is_a?(Hash) or subst.respond_to?(:to_shaven)
      end

      def transform
        [node, combine_scope(scope, subst)]
      end
    end # Scopeable
  end # Transformer
end # Shaven
