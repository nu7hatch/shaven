require 'shaven/transformers/content'

module Shaven
  module Transformer
    class TextOrNode < Content
      def allow_continue?
        false
      end

      def transform!
        if subst_value.is_a?(Nokogiri::XML::Node)
          node.inner_html = subst_value
        else
          node.content = subst_value.to_s
        end

        @result = node
      end
    end # TextOrNode
  end # Transformer
end # Shaven
