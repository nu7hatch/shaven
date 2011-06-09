require 'shaven/tag'

module Shaven
  module Helpers
    module HTML
      def tag(tag, attrs={}, &content)
        Shaven::Tag.new(tag, attrs.stringify_keys, content, @document)
      end

      def a(attrs={}, &label)
        tag(:a, attrs, &label)
      end

      def img(attrs={})
        tag(:img, attrs)
      end

      def div(attrs={}, &content)
        tag(:div, attrs, &content)
      end
    end # HTML
  end # Helpers
end # Shaven
