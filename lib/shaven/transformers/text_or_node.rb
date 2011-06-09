require 'shaven/transformers/content'

module Shaven
  module Transformer
    class TextOrNode < Content
      def allow_continue?
        false
      end

      def transform!
        @result = node.update! { subst_value }
      end
    end # TextOrNode
  end # Transformer
end # Shaven
