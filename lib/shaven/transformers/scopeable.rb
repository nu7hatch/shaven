require 'shaven/transformers/content'

module Shaven
  module Transformer
    class Scopeable < Content
      def can_be_transformed?
        # Can be applied only with hashes or preseneters. 
        super && (subst_value.is_a?(Hash) || subst_value.is_a?(Presenter))
      end

      def allow_continue?
        false
      end

      def transform!
        @result = node
        @scope  = combine_scope(scope, subst_value, subst_name)
      end
    end # Scopeable
  end # Transformer
end # Shaven
