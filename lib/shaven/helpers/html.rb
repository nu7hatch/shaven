module Shaven
  module Helpers
    module HTML
      def tag(tag, attrs, &content)
        Shaven::Tag.new(tag, attrs, content, @document)
      end

      def a(attrs, &label)
        attrs['data-method']  ||= attrs.delete(:method)
        attrs['data-confirm'] ||= attrs.delete(:confirm)
        attrs['data-remote']  ||= attrs.delete(:remote)

        tag(:a, attrs, &label)
      end

      def img(attrs)
        tag(:img, attrs)
      end

      def div(attrs, &content)
        tag(:div, attrs, &content)
      end
    end # HTML
  end # Helpers
end # Shaven
