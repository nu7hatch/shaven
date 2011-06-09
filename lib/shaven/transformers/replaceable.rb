require 'shaven/transformers/content'

module Shaven
  module Transformer
    class Replaceable < Content
      def can_be_transformed?
        # Can be applied with replacement nodes or with current node updates. 
        super && subst_value.shaven_node? && subst_value.replace_with?(node)
      end

      def allow_continue?
        false
      end

      def transform!
        @result = subst_value
      end
    end # Replaceable
  end # Transformer
end # Shaven
