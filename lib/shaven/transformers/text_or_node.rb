module Shaven
  module Transformer
    class TextOrNode < Base
      def can_be_transformed?
        true
      end

      def transform
        [node.update! { subst }, nil]
      end
    end # TextOrNode
  end # Transformer
end # Shaven
