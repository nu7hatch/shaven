module Shaven
  module Transformer
    class Replaceable < Base
      def can_be_transformed?
        subst.is_a?(Nokogiri::XML::Node) and subst.replace_with?(node)
      end
      
      def transform
        [subst, nil]
      end
    end # Replaceable
  end # Transformer
end # Shaven
